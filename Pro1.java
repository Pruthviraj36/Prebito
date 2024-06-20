// W.A.P. to find the largest number from given 3 numbers using conditional operator.

// Import required classes for perform the program
import java.util.Scanner;

class Pro1 {
    public static void main(String[] args){
        // Create instance of the Scanner class
        Scanner sc = new Scanner(System.in);

        // Read the three numbers from the user
        System.out.print("Enter the number 1 here : ");
        double n1 = sc.nextDouble();
        System.out.print("Enter the number 2 here : ");
        double n2 = sc.nextDouble();
        System.out.print("Enter the number 3 here : ");
        double n3 = sc.nextDouble();

        // Find the largest number from the given three number and check all the condition that two numbers all equals or not.
        if(n1>n2 && n1>n3) {
            System.out.print(n1 + " Is the grestest above them!");
        }
        else if(n2>n3 && n2>n3) {
            System.out.print(n2 + " Is the grestest above them!");
        }
        else if(n3>n1 && n3>n2){
            System.out.print(n3 + " Is the greatest above them!");
        }
        else if(n1==n2 && n1>n3){
            System.out.print("Number-1 and Number-2 Are Greatest = " + n1);
        }
        else if(n1==n2 && n1<n3){
            System.out.print("Number-3 Is Largest = " + n3);
        }
        else if(n2==n3 && n2>n1) {
            System.out.print("Number-2 and Number-3 Are Greatest = " + n2);
        }
        else if(n2==n3 && n2<n1) {
            System.out.print("Number-1 Is Largest = " + n1);
        }
        else if(n3==n1 && n3>n2) {
            System.out.print("Number-3 and Number-1 Are Greatest = " + n3);
        }
        else if(n3==n1 && n3<n2) {
            System.out.print("Number-1 Is Largest = " + n2);
        }
        else {
            System.out.print("All the numbers are equals and greatest!");
        }
    }
}