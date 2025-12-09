# Codebase Overview

This is a **Spring Boot e-commerce REST API** built with Java 21. It's a well-structured application following clean architecture principles with clear separation of concerns.

## Technology Stack
- **Framework**: Spring Boot 3.4.1
- **Language**: Java 21
- **Database**: MySQL with Flyway migrations
- **Security**: Spring Security with JWT authentication
- **Payment**: Stripe integration
- **Documentation**: OpenAPI/Swagger
- **Build Tool**: Maven
- **Additional**: Lombok, MapStruct, Thymeleaf

## Architecture Diagrams

### System Architecture

```mermaid
graph TB
    subgraph "Presentation Layer"
        AC[AdminController]
        AuthC[AuthController]
        CC[CartController]
        OC[OrderController]
        PC[ProductController]
        UC[UserController]
        ChC[CheckoutController]
    end
    
    subgraph "Security Layer"
        JWT[JWT Authentication]
        SEC[Security Config]
        RULES[Security Rules]
    end
    
    subgraph "Service Layer"
        AS[AuthService]
        CS[CartService]
        OS[OrderService]
        US[UserService]
        ChS[CheckoutService]
    end
    
    subgraph "Data Layer"
        UR[UserRepository]
        CR[CartRepository]
        OR[OrderRepository]
        PR[ProductRepository]
        AR[AddressRepository]
    end
    
    subgraph "External Services"
        STRIPE[Stripe Payment Gateway]
        DB[(MySQL Database)]
    end
    
    AC --> AS
    AuthC --> AS
    CC --> CS
    OC --> OS
    UC --> US
    ChC --> ChS
    
    AS --> UR
    CS --> CR
    OS --> OR
    US --> UR
    ChS --> STRIPE
    
    UR --> DB
    CR --> DB
    OR --> DB
    PR --> DB
    AR --> DB
    
    JWT --> SEC
    SEC --> RULES
```

### Domain Model Diagram

```mermaid
erDiagram
    USER {
        Long id PK
        String name
        String email
        String password
        Role role
    }
    
    PRODUCT {
        Long id PK
        String name
        String description
        BigDecimal price
        Long category_id FK
    }
    
    CATEGORY {
        Long id PK
        String name
    }
    
    CART {
        Long id PK
        Long user_id FK
        BigDecimal total_price
    }
    
    CART_ITEM {
        Long id PK
        Long cart_id FK
        Long product_id FK
        Integer quantity
    }
    
    ORDER {
        Long id PK
        Long customer_id FK
        PaymentStatus status
        LocalDateTime created_at
        BigDecimal total_price
    }
    
    ORDER_ITEM {
        Long id PK
        Long order_id FK
        Long product_id FK
        Integer quantity
    }
    
    ADDRESS {
        Long id PK
        Long user_id FK
        String street
        String city
        String state
        String zip_code
    }
    
    WISHLIST {
        Long user_id FK
        Long product_id FK
    }
    
    USER ||--o{ ADDRESS : has
    USER ||--o{ CART : owns
    USER ||--o{ ORDER : places
    USER }o--o{ PRODUCT : favorites
    
    PRODUCT }o--|| CATEGORY : belongs_to
    PRODUCT ||--o{ CART_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : contains
    
    CART ||--o{ CART_ITEM : contains
    ORDER ||--o{ ORDER_ITEM : contains
```

### API Flow Diagram

```mermaid
sequenceDiagram
    participant Client
    participant API
    participant Auth
    participant Cart
    participant Order
    participant Stripe
    participant DB
    
    Client->>API: GET /products
    API->>DB: Fetch products
    DB-->>API: Product list
    API-->>Client: Products response
    
    Client->>API: POST /carts
    API->>Cart: Create cart
    Cart->>DB: Save cart
    DB-->>Cart: Cart created
    Cart-->>API: Cart ID
    API-->>Client: Cart response
    
    Client->>API: POST /carts/{id}/items
    API->>Cart: Add item to cart
    Cart->>DB: Update cart
    DB-->>Cart: Updated
    Cart-->>API: Success
    API-->>Client: Item added
    
    Client->>API: POST /users (register)
    API->>DB: Save user
    DB-->>API: User created
    API-->>Client: Registration success
    
    Client->>API: POST /auth/login
    API->>Auth: Authenticate
    Auth->>DB: Verify credentials
    DB-->>Auth: User valid
    Auth-->>API: JWT token
    API-->>Client: Login response
    
    Client->>API: POST /checkout (with JWT)
    API->>Auth: Validate token
    Auth-->>API: Token valid
    API->>Order: Create order from cart
    Order->>DB: Save order
    API->>Stripe: Create checkout session
    Stripe-->>API: Checkout URL
    API-->>Client: Checkout URL
    
    Client->>Stripe: Complete payment
    Stripe->>API: POST /checkout/webhook
    API->>Order: Update order status
    Order->>DB: Update status
    DB-->>Order: Updated
```

## Package Structure

The application follows a **feature-based package structure**:

```
com.codewithmosh.store/
├── admin/          # Admin functionality
├── auth/           # Authentication & JWT
├── carts/          # Shopping cart management
├── common/         # Shared utilities & exceptions
├── orders/         # Order processing
├── payments/       # Stripe payment integration
├── products/       # Product catalog
└── users/          # User management
```

Each package contains:
- **Controller**: REST endpoints
- **Service**: Business logic
- **Repository**: Data access
- **Entity**: JPA entities
- **DTO**: Data transfer objects
- **Mapper**: Entity-DTO mapping
- **SecurityRules**: Authorization rules

## Key Features

1. **Product Management**: Browse products by category
2. **Shopping Cart**: Add/remove items, manage quantities
3. **User Management**: Registration, authentication, profiles
4. **Order Processing**: Convert carts to orders
5. **Payment Integration**: Stripe checkout and webhooks
6. **Security**: JWT-based authentication with role-based access
7. **API Documentation**: Swagger/OpenAPI integration

## Dependencies Analysis

### Core Spring Boot Dependencies
- `spring-boot-starter-web` - REST API capabilities
- `spring-boot-starter-data-jpa` - Database access
- `spring-boot-starter-security` - Authentication & authorization
- `spring-boot-starter-validation` - Input validation
- `spring-boot-starter-thymeleaf` - Template engine

### Database & Migration
- `mysql-connector-j` - MySQL database driver
- `flyway-core` & `flyway-mysql` - Database migrations

### Security & JWT
- `jjwt-api`, `jjwt-impl`, `jjwt-jackson` - JWT token handling
- `thymeleaf-extras-springsecurity6` - Thymeleaf security integration

### Utilities & Mapping
- `lombok` - Boilerplate code reduction
- `mapstruct` & `mapstruct-processor` - Entity-DTO mapping
- `spring-dotenv` - Environment variable management

### External Integrations
- `stripe-java` - Payment processing
- `springdoc-openapi-starter-webmvc-ui` - API documentation

## Database Schema

The application uses Flyway migrations with the following key tables:
- `users` - User accounts with roles
- `products` & `categories` - Product catalog
- `carts` & `cart_items` - Shopping cart functionality
- `orders` & `order_items` - Order management
- `addresses` - User shipping addresses
- `wishlist` - User favorite products

The codebase demonstrates solid Spring Boot practices with clean separation of concerns, proper exception handling, and comprehensive security implementation.