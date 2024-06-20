// W.A.P. to read n numbers in an array and remove the duplicates from an array.

// Import the required classes to implement the problem
import java.util.*;

public class Pro9 {
    public static void main(String[] args) {
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the size from the user
        System.out.print("Enter the size of the array : ");
        int size = sc.nextInt();

        // Implement the array and read the elements of the array from the user
        int[] arr = new int[size];

        for (int i = 0; i < arr.length; i++) {
            System.out.printf("[%d] : ", i);
            arr[i] = sc.nextInt();
        }

        // // Compare the array and remove the duplicates
        // int[] temp = arr;
        
        // for (int i = 0; i < temp.length; i++) {
        //     if (temp[i] == arr[i]) {
        //         break;
        //     }else{
        //         arr[i] = temp[i];
        //     }
        // }

        // print the array
        for (int i = 0; i < arr.length; i++) {
            System.out.println(arr[i]);
        }
    }
}
