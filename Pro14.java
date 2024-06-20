// Accept a positive number from the user and print a message stating whether the number entered is even or odd WITHOUT using the module (%)operator and if... else statements.

// Import the required classes to implement the problem
import java.util.*;

public class Pro14 {
    public static void main(String[] args) {
        // Instance the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the number from the user
        System.out.print("Enter the positive number here : ");
        int n = sc.nextInt();

        // Check the condition without using the conditional and % operator
        System.out.println((n&1)==0 ? "Is even no" : "Is Odd number");
    }
}
