// W.A.P. to print odd numbers that are divisible by 7 but not divisible by 3 between 150 and 445.

// Import the required classes for implement to problem
import java.util.*;

public class Pro7 {
    public static void main(String[] args) {
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the start and end range from the user
        System.out.print("Start : ");
        int start = sc.nextInt();
        System.out.print("End : ");
        int end = sc.nextInt();

        // Loop through the all the numbers and check the numbers
        for (int i = start; i <= end; i++) {
            if (i%2!=0) {
                if (i%7==0 && i%3!=0) {
                    System.out.print(i + ", ");
                }
            }
        }
    }
}
