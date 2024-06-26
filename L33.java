import java.util.Scanner;
class L33 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
		System.out.println("Enter Number 1");
		float num1 = sc.nextFloat();
		System.out.println("Enter Number 2");
		float num2 = sc.nextFloat();
		System.out.println("Original Number " + num1 +", "+ num2);
		swap(num1, num2);
    }
    public static void swap(float num1, float num2){
		float temp;
		temp = num1;
		num1 = num2;
		num2 = temp;
		System.out.println("Swapped Number " + num1 +", "+ num2);
	}
}