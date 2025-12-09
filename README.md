# Modular Coding - AL Code Decoupling Demo

## Description

This Business Central extension demonstrates various methods and patterns for decoupling code in AL development. The app showcases best practices for creating maintainable, testable, and scalable AL applications through proper separation of concerns and modular design patterns.

## Purpose

The Modular Coding app serves as a comprehensive demonstration of:

- **Interface-based Programming**: Using interfaces to decouple implementations from contracts
- **Dependency Injection**: Implementing DI patterns in AL to reduce tight coupling
- **Event-driven Architecture**: Leveraging Business Central's event system for loose coupling
- **Factory Patterns**: Creating objects without tight coupling to specific classes
- **Strategy Pattern**: Implementing different algorithms through interchangeable strategies
- **Observer Pattern**: Using events and subscribers for reactive programming
- **Repository Pattern**: Abstracting data access layers
- **Service Layer Pattern**: Separating business logic from presentation logic

## Key Benefits of Code Decoupling

1. **Maintainability**: Changes to one module don't cascade through the entire codebase
2. **Testability**: Individual components can be unit tested in isolation
3. **Reusability**: Modules can be reused across different parts of the application
4. **Scalability**: New features can be added with minimal impact on existing code
5. **Flexibility**: Different implementations can be swapped without affecting dependent code

## Project Structure

```
src/
├── Permissions/          # Demo about permissions in memory
```

## Getting Started

1. **Prerequisites**:
   - Business Central Development Environment
   - AL Language Extension for VS Code
   - AL-Go for GitHub (recommended for CI/CD)

2. **Installation**:
   - Clone this repository
   - Open in VS Code with AL Language Extension
   - Download symbols: `AL: Download Symbols`
   - Build and publish: `AL: Publish`

3. **Exploration**:
   - Start with the examples in the `Examples/` folder
   - Review interface definitions in `Interfaces/`
   - Examine concrete implementations and their usage patterns

## AL Best Practices for Code Organization

### 1. File and Object Naming Conventions

- **Prefixes**: Use consistent prefixes for all objects (e.g., `MC` for Modular Coding)
- **Descriptive Names**: Choose clear, descriptive names that indicate purpose
- **File Structure**: Organize files by functionality, not by object type
- **Naming Pattern**: `[Prefix][FunctionalArea][ObjectType][Description]`

### 2. Interface Design Principles

```al
// Good: Clear contract definition
interface "MC Order Processor"
{
    procedure ProcessOrder(OrderNo: Code[20]): Boolean;
    procedure ValidateOrder(OrderNo: Code[20]): Text;
}

// Implementation
codeunit 50101 "MC Standard Order Processor" implements "MC Order Processor"
{
    // Implementation details
}
```

### 3. Event-Driven Programming

```al
// Publisher
codeunit 50102 "MC Order Events"
{
    [IntegrationEvent(false, false)]
    internal procedure OnBeforeOrderProcess(OrderNo: Code[20]; var IsHandled: Boolean)
    begin
    end;
}

// Subscriber
codeunit 50103 "MC Order Validation Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MC Order Events", 'OnBeforeOrderProcess', '', true, true)]
    local procedure HandleOrderValidation(OrderNo: Code[20]; var IsHandled: Boolean)
    begin
        // Validation logic
    end;
}
```

### 4. Dependency Injection Pattern

```al
// Service interface
interface "MC Data Service"
{
    procedure GetCustomerData(CustomerNo: Code[20]): JsonObject;
}

// Consumer codeunit
codeunit 50104 "MC Customer Manager"
{
    var
        DataService: Interface "MC Data Service";

    procedure Initialize(NewDataService: Interface "MC Data Service")
    begin
        DataService := NewDataService;
    end;

    procedure ProcessCustomer(CustomerNo: Code[20])
    var
        CustomerData: JsonObject;
    begin
        CustomerData := DataService.GetCustomerData(CustomerNo);
        // Process data
    end;
}
```

### 5. Error Handling and Logging

```al
// Centralized error handling
codeunit 50105 "MC Error Handler"
{
    procedure HandleError(ErrorCode: Code[20]; ErrorMessage: Text; Context: Text)
    begin
        // Log error
        LogError(ErrorCode, ErrorMessage, Context);
        
        // Notify users appropriately
        Error(GetUserFriendlyMessage(ErrorCode));
    end;
}
```

### 6. Configuration Management

```al
// Configuration table for settings
table 50100 "MC Configuration"
{
    fields
    {
        field(1; "Setting Key"; Code[50]) { }
        field(2; "Setting Value"; Text[250]) { }
        field(3; "Description"; Text[100]) { }
    }
    
    keys
    {
        key(PK; "Setting Key") { Clustered = true; }
    }
}
```

### 7. Testing Strategies

```al
// Test codeunit with proper isolation
codeunit 50199 "MC Order Processor Tests"
{
    Subtype = Test;

    [Test]
    procedure TestOrderProcessingSuccess()
    var
        MockOrderProcessor: Codeunit "MC Mock Order Processor";
        OrderManager: Codeunit "MC Order Manager";
    begin
        // Arrange
        OrderManager.SetOrderProcessor(MockOrderProcessor);
        
        // Act & Assert
        assertthat.IsTrue(OrderManager.ProcessOrder('ORDER001'), 'Order should process successfully');
    end;
}
```

## Development Guidelines

### Code Quality Standards

1. **Single Responsibility**: Each codeunit should have one clear purpose
2. **Open/Closed Principle**: Open for extension, closed for modification
3. **Interface Segregation**: Create focused, specific interfaces
4. **Dependency Inversion**: Depend on abstractions, not concretions

### Performance Considerations

1. **Lazy Loading**: Load data only when needed
2. **Caching Strategies**: Implement appropriate caching for frequently accessed data
3. **Bulk Operations**: Process records in batches when possible
4. **Query Optimization**: Use appropriate filters and sorting

### Security Best Practices

1. **Permissions**: Define granular permission sets
2. **Data Validation**: Always validate input parameters
3. **Audit Trails**: Log important business operations
4. **Secure Coding**: Follow AL security guidelines

## Contributing

When contributing to this project:

1. Follow the established naming conventions
2. Add comprehensive XML documentation
3. Include unit tests for new functionality
4. Update this README for significant changes
5. Ensure code follows the decoupling patterns demonstrated

## License

This project is intended for educational and demonstration purposes.

## Contact

For questions or suggestions about this demo app, please refer to the project repository or contact the development team.

---

*This app demonstrates modern AL development practices focused on creating maintainable, decoupled, and testable Business Central extensions.*