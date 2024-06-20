// W.A.P. to check given number is palindrome or not.

// Import the required class for implement the program
import java.util.Scanner;

class Pro3 {
    public static void main(String[] args){
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the number from the user
        System.out.print("Enter the number here : ");
        int n = sc.nextInt();

        // Temp variables to store the numbers
        int rem;
        int sum = 0;
        int temp=n;

        // Loop through the all the numbers
        while (n>0) {
            rem=n%10; // Getting reminder
            sum=(sum*10)+rem;
            n=n/10;
        }

        // Check the condition and check the number is equal with sum
        if (temp==sum) {
            System.out.println("Equal!");
        }else{
            System.out.println("Not equal!");
        }
    }
}