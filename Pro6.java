// W.A.P. to read n numbers in an array and print the sum of odd numbers & even numbers.

// Import the required classes for implement the problem
import java.util.*;

public class Pro6 {
    public static void main(String[] args) {
        // Instance of the scanner class
        Scanner sc = new Scanner(System.in);

        // Read the size of the array from the user
        System.out.print("Enter the size of the array : ");
        long size = sc.nextLong();

        // Declare the array and read the element of the array
        int[] arr = new int[(int)size];

        for (int i = 0; i < arr.length; i++) {
            System.out.printf("[%d] : ", i);
            arr[i] = sc.nextInt();
        }

        int odd = 0;
        int even = 0;

        for (int i = 0; i < arr.length; i++) {
            if (arr[i]%2==0) {
                even = even + arr[i];
            }else{
                odd = odd + arr[i];
            }
        }

        // Print the sum of the array odd and even elements
        System.out.println("The Sum of the even element of the array is : " + even);
        System.out.println("The Sum of the odd element of the array is : " + odd);
    }
}
