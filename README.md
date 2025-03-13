# Internal Wallet Transactional System - Architecture Overview

## Design Patterns Used

### 1. Polymorphic Associations
We're using polymorphic associations for the `Wallet` model, allowing any entity (User, Team, Stock) to have its own wallet through the `owner` association. This creates a flexible architecture where any model can have a wallet without changing the database schema.

### 2. Service Objects Pattern
Transaction operations are encapsulated in service objects (`TransactionService`, `WalletService`, `JwtService`) to separate business logic from models and controllers, making the codebase more maintainable and testable.

### 3. Single Table Inheritance (STI)
The transaction system implemented with STI principles where different transaction types (credit, debit, transfer) share the same table but have different models and behavior based on the type.

Here is the Transaction-STI structure:
```
Transaction
   ▲
   │
   ├── CreditTransaction
   ├── DebitTransaction
   ├── TransferTransaction
```

### 4. Repository Pattern
The `LatestStockPrice` library encapsulates external API interactions, following repository pattern principles.

## Core Components

### Models
- **Wallet**: Represents a money container with polymorphic association to an owner.
- **Transaction**: Stores all money movements with validations for different transaction types.
- **CreditTransaction**, **DebitTransaction**, **TransferTransaction**: Transaction-related models inherited from `Transaction` model (STI principle)
- **User, Team, Stock**: Example entities that can own wallets.

### Services
- **BaseTransactionService**: Base Transaction Service for handling all transation operations (deposit, withdrawal, transfer) with ACID compliance.
- **DepositService**: Handles deposit transaction.
- **WithdrawalService**: Handles withdrawal transaction.
- **TransferService**: Handles money transfer between wallets.
- **TokenService**: Manages JWT token generation and validation for authentication.
- **AuthenticationService**: Handles token-based user authentication.

### Controllers
- **SessionsController**: Handles user authentication.
- **UsersController**: Provides User information.
- **TeamsController**: Provides Team information.
- **WalletsController**: Provides Wallet information.
- **TransactionsController**: Manages money movement operations.
- **StocksController**: Provide Stocks information.

## Database Schema

The database uses foreign keys and transactions to ensure data integrity:

1. **wallets**: Stores wallet information with polymorphic association to owners (`User`, `Team`, `Stock`).
2. **transactions**: Records all money movements with proper relationships to source and target wallets.
3. **users, teams, stocks**: Example entity tables that have wallets.

## Transaction System

The transaction system ensures:
- Every money movement is recorded with proper source and target information
- Database operations use transactions to maintain ACID compliance
- Wallet balances are calculated by summing transaction records
- Proper validations for each transaction type (credit, debit, transfer)

## Authentication

Custom JWT-based authentication without external gems, as required.

## External Libraries

The `LatestStockPrice` library in the `lib` folder provides a clean interface to the external stock price API, following gem-style conventions.


# Internal Wallet Transaction System API (Rails API)

This API provides authentication, wallet transactions, money transfers, and stock data retrieval.

## **Base URL**
```
/api/v1/
```

## **Authentication**
### **User Login**
**Endpoint:**  
```http
POST /api/v1/login
```
**Request Body:**
```json
{
  "email": "user1@example.com",
  "password": "securepassword"
}
```
**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE3NDE5MzIwMDl9.pOseNHLfan6g30D-mYXZgyrG7xxfbyQ5JuB_uTvPIEo",
  "user": {
    "id": 2,
    "email": "user1@example.com",
    "name": "User One",
  }
}
```

## **User**
### **Get User Profile**
**Endpoint:**  
```http
GET /api/v1/user
```
**Response:**
```json
{
  "id": 2,
  "email": "user1@example.com",
  "name": "User One",
  "wallet": {
    "id": 2,
    "balance": "7000.0"
  }
}
```

## **Wallets & Transactions**
### **Get Wallet Balance**
**Endpoint:**  
```http
GET /api/v1/wallets/:id
```
**Response:**
```json
{
  "id": 1,
  "owner_type": "User",
  "owner_id": 1,
  "balance": "8000.0"
}
```

### **Get Wallet Transactions**
**Endpoint:**  
```http
GET /api/v1/wallets/:id/transactions
```
**Response:**
```json
[
  {
    "id": 14,
    "source_wallet_id": 1,
    "target_wallet_id": 2,
    "amount": "1000.0",
    "description": "Transfer test",
    "created_at": "2025-03-13T05:21:07.255Z",
    "type": "TransferTransaction"
  },
  {
    "id": 12,
    "source_wallet_id": 1,
    "target_wallet_id": null,
    "amount": "100000.0",
    "description": "Withdraw 100k",
    "created_at": "2025-03-13T05:20:47.208Z",
    "type": "DebitTransaction"
  },
  {
    "id": 1,
    "source_wallet_id": null,
    "target_wallet_id": 1,
    "amount": "10000.0",
    "description": "Initial funding",
    "created_at": "2025-03-13T05:18:40.717Z",
    "type": "CreditTransaction"
  }
]
```

### **Deposit Money**
**Endpoint:**  
```http
POST /api/v1/wallets/:id/deposit
```
**Request Body:**
```json
{
  "amount": 100000,
  "description": "Initial funding"
}
```
**Response:**
```json
{
  "id": 11,
  "source_wallet_id": null,
  "target_wallet_id": 1,
  "amount": "100000.0",
  "description": "Initial funding",
  "created_at": "2025-03-13T05:20:36.067Z",
  "updated_at": "2025-03-13T05:20:36.067Z"
}
```

### **Withdraw Money**
**Endpoint:**  
```http
POST /api/v1/wallets/:id/withdraw
```
**Request Body:**
```json
{
  "amount": 1000,
  "description": "Withdraw 1000"
}
```
**Response:**
```json
{
  "id": 16,
  "source_wallet_id": 1,
  "target_wallet_id": null,
  "amount": "1000.0",
  "description": "Withdraw 1000",
  "created_at": "2025-03-13T06:10:06.520Z",
  "updated_at": "2025-03-13T06:10:06.520Z"
}
```

### **Transfer Money**
**Endpoint:**  
```http
POST /api/v1/transfer
```
**Request Body:**
```json
{
  "source_wallet_id": 1,
  "target_wallet_id": 2,
  "amount": 1000,
  "description": "Transfer test"
}
```
**Response:**
```json
{
  "id": 15,
  "source_wallet_id": 1,
  "target_wallet_id": 2,
  "amount": "1000.0",
  "description": "Transfer test",
  "created_at": "2025-03-13T05:21:17.459Z",
  "updated_at": "2025-03-13T05:21:17.459Z"
}
```

## **Stock Market**
### **Get All Stocks**
**Endpoint:**  
```http
GET /api/v1/stocks
```
**Response:**
```json
[
  {
    "id": 1,
    "symbol": "AAPL",
    "name": "Apple Inc.",
    "current_price": "216.98",
    "updated_at": "2025-03-13T05:18:40.675Z"
  },
  {
    "id": 2,
    "symbol": "MSFT",
    "name": "Microsoft Corporation",
    "current_price": "383.27",
    "updated_at": "2025-03-13T05:18:40.682Z"
  },
  {
    "id": 3,
    "symbol": "GOOGL",
    "name": "Alphabet Inc.",
    "current_price": "167.11",
    "updated_at": "2025-03-13T05:18:40.689Z"
  }
]
```

### **Get Stock Price by Symbol**
**Endpoint:**  
```http
GET /api/v1/stocks/:symbol
```
**Example:** `/api/v1/stocks/AAPL`  
**Response:**
```json
{
  "current_price": "216.98",
  "symbol": "AAPL",
  "id": 1,
  "name": "Apple Inc.",
  "updated_at": "2025-03-13T05:20:09.594Z"
}
```

## **Teams**
### **Get All Teams**
**Endpoint:**  
```http
GET /api/v1/teams
```
**Response:**
```json
[
  { "id": 1, "name": "Engineering" },
  { "id": 2, "name": "Finance" }
]
```

### **Get Team by ID**
**Endpoint:**  
```http
GET /api/v1/teams/:id
```
**Response:**
```json
{
  "id": 1,
  "name": "Engineering"
}
```

## **Notes**
- All requests should include a **valid session** for authentication.
- Response data format may change based on implementation.
- Stock prices are fetched from an **external API**.
- Token-based Authentication: If using JWT authentication, include the token in the HTTP headers for every request: `Authorization: Bearer YOUR_JWT_TOKEN`
