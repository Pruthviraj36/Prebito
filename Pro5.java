// W.A.P. to print series 1, 3, 6, 10, 15, …

// Import the required classes to implement the problem
import java.util.*;

public class Pro5 {
    public static void main(String[] args) {
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the number from the user
        System.out.print("Enter the range of the number : ");
        int n = sc.nextInt();

        // Initial variables for storing the numbers
        int sum = 0;
        int z = 1;

        // Loop through the numbers and print the all the numbers
        for (int i = 1; i <= n; i++) {
            sum = sum + z;
            System.out.print(sum + ", ");
            z++;
        }
    }
}
