// W.A.P. to check given number is odd or even using bitwise operator.

// Import the required classes to implement the problem
import java.util.Scanner;

public class Pro4 {
    public static void main(String[] args) {
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the number from the user
        System.out.print("Enter the number here : ");
        int n = sc.nextInt();

        // Check the number is even or odd using bitwise operator
        if ((n & 1) == 0) {
            System.out.println(n + " Is the Even Number!");
        }else{
            System.out.println(n + " Is the Odd Number!");
        }
    }
}
