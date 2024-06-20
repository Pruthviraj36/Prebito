// W.A.P. to check given number is prime or not.

// Import the required class to implement the program
import java.util.Scanner;

class Pro2 {
    public static void main(String[] args) {
        // Instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the number from the user
        System.out.print("Enter the number here : ");
        int n = sc.nextInt();

        boolean flag = false;

        // Condition for check the number is prime or not
        if(n==1) {
            System.out.print(n + " Is not prime number!");
        }
        else{
            for(int i=2; i<n; i++) {
                if(n%i==0) {
                    flag = true;
                    break;
                }
            }
        }

        // Check the condition and print the prime number
        if(flag) {
            System.out.print(n + " Is not Prime Number!");
        }else{
            System.out.print(n + " Is Prime Number!");
        }
    }
}