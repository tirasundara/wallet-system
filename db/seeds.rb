# db/seeds.rb

# Create some users
user0 = User.create!(
  email: 'user0@example.com',
  password: 'password',
  name: 'User Zero'
)

user1 = User.create!(
  email: 'user1@example.com',
  password: 'password',
  name: 'User One'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password',
  name: 'User Two'
)

# Create team
team = Team.create!(name: 'Engineering Team')

# Create some stocks
stocks = [
  { symbol: 'AAPL', name: 'Apple Inc.' },
  { symbol: 'MSFT', name: 'Microsoft Corporation' },
  { symbol: 'GOOGL', name: 'Alphabet Inc.' },
  { symbol: 'AMZN', name: 'Amazon.com Inc.' },
  { symbol: 'META', name: 'Meta Platforms Inc.' }
]

stocks.each do |stock_attrs|
  Stock.create!(stock_attrs)
end

# Add some initial funds to wallets
TransactionServices::DepositService.call(
  wallet: user0.wallet,
  amount: 10_000,
  description: 'Initial funding'
)

TransactionServices::DepositService.call(
  wallet: user1.wallet,
  amount: 5000,
  description: 'Initial funding'
)

TransactionServices::DepositService.call(
  wallet: user2.wallet,
  amount: 5000,
  description: 'Initial funding'
)

TransactionServices::DepositService.call(
  wallet: team.wallet,
  amount: 20_000,
  description: 'Initial team funding'
)

# Add funds to stock wallets
Stock.all.each do |stock|
  TransactionServices::DepositService.call(
    wallet: stock.wallet,
    amount: rand(1000..5000),
    description: 'Initial stock funding'
  )
end

# Create some sample transactions
# Transfer from user0 to team
TransactionServices::TransferService.call(
  source_wallet: user0.wallet,
  target_wallet: team.wallet,
  amount: 1000,
  description: 'Project funding'
)

# Transfer between users
TransactionServices::TransferService.call(
  source_wallet: user1.wallet,
  target_wallet: user2.wallet,
  amount: 500,
  description: 'Reimbursement'
)

puts "Seed data created successfully!"
