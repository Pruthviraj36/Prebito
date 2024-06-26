import java.util.Scanner;

public class L36 {

    public static double celsiusToFahrenheit(double celsius) {
        return (celsius * 9/5) + 32;
    }

    public static double fahrenheitToCelsius(double fahrenheit) {
        return (fahrenheit - 32) * 5/9;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Temperature Conversion Program");
        System.out.println("1. Celsius to Fahrenheit");
        System.out.println("2. Fahrenheit to Celsius");

        System.out.print("Enter your choice (1/2): ");
        int choice = scanner.nextInt();

        if (choice == 1) {
            System.out.print("Enter temperature in Celsius: ");
            double celsius = scanner.nextDouble();
            System.out.printf("%.2f Celsius is equal to %.2f Fahrenheit%n", celsius, celsiusToFahrenheit(celsius));
        } else if (choice == 2) {
            System.out.print("Enter temperature in Fahrenheit: ");
            double fahrenheit = scanner.nextDouble();
            System.out.printf("%.2f Fahrenheit is equal to %.2f Celsius%n", fahrenheit, fahrenheitToCelsius(fahrenheit));
        } else {
            System.out.println("Invalid choice");
        }
    }
}
