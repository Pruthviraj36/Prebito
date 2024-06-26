import java.util.ArrayList;

class BankAccount {
    private int accountNumber;
    private double balance;
    private String accountHolder;
    private String accountName;

    public BankAccount(int accountNumber, double balance, String accountHolder, String accountName) {
        this.accountNumber = accountNumber;
        this.balance = balance;
        this.accountHolder = accountHolder;
        this.accountName = accountName;
    }

    public int getAccountNumber() {
        return accountNumber;
    }

    public double getBalance() {
        return balance;
    }

    public String getAccountHolder() {
        return accountHolder;
    }

    public String getAccountName() {
        return accountName;
    }

    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposit Successful. New balance is " + balance);
        } else {
            System.out.println("Invalid deposit amount");
        }
    }

    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrawal Successful. New balance is " + balance);
        } else if (amount > balance) {
            System.out.println("Insufficient balance");
        } else {
            System.out.println("Invalid withdrawal amount");
        }
    }

    public void checkBalance() {
        System.out.println("Current balance is " + balance);
    }
}

public class Main {
    public static void main(String[] args) {
        ArrayList<BankAccount> bankAccounts = new ArrayList<>();

        BankAccount account1 = new BankAccount(1234, 1000, "John Doe", "Savings Account");
        BankAccount account2 = new BankAccount(5678, 500, "Jane Doe", "Current Account");

        bankAccounts.add(account1);
        bankAccounts.add(account2);

        account1.deposit(500);
        account1.withdraw(200);
        account1.checkBalance();

        account2.deposit(1000);
        account2.withdraw(800);
        account2.checkBalance();
    }
}