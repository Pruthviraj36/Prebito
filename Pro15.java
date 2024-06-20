/*
 * 15	Create a program that would accept a string from the user and print a pattern. For example, if
the user enters “Hello”, it should print a pattern as follows:
H
He
Hel
Hell
Hello
 */

 // Import the required classes to implement the problem
 import java.util.*;

public class Pro15 {
    public static void main(String[] args) {
        // Create instance of the class
        Scanner sc = new Scanner(System.in);

        // Get the string from the user
        System.out.println("Enter the string here : ");
        String str = sc.nextLine();

        // Get the length of the string
        int len = str.length();


        // Print the character one by one in the sequence
        for (int i = 0; i < len; i++) {
            for (int j = 0; j <= i; j++) {
                System.out.print(str.charAt(j));
            }
            System.out.println(); // This get an one space after at one loop
        }
    }
}
