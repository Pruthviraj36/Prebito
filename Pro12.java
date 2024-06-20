// 12	Accept two integers from the user and calculate the sum of last digits of both the integers. For example, if the numbers are 27 and 459, then the sum of last digits would be 16 (i.e. 7 + 9).

// Import the required class to implement the problem
import java.util.*;

public class Pro12 {
    public static void main(String[] args) {
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the two numbers from the user
        System.out.print("Enter the number 1 here : ");
        int n1 = sc.nextInt();
        System.out.print("Enter the number 2 here : ");
        int n2 = sc.nextInt();

        // Get the last digit of the two numbers
        int l1 = n1%10;
        int l2 = n2%10;
        int sum = l1 + l2;

        // Print the sum of the last digits
        System.out.println("The sum of last digit " + n1 + " + " + n2 + " = " + sum);
    }
}
