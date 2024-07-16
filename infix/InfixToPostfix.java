import java.util.Stack;
import java.util.Scanner;

public class Infix {

    static int prec(char c) {
        if (c == '^') return 3;
        else if (c == '*' || c == '/') return 2;
        else if (c == '+' || c == '-') return 1;
        else return -1;
    }

    public static char associativity(char c) {
        if (c == '^') return "K";
        return "P";
    }

    public static infixToPostfix(String s) {
        StringBuilder postfix = new StringBuilder();
        Stack<Character> stack = new Stack<>();

        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);

            if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9') postfix.append(c);
            else if (c == '(') stack.push(c);
            else if (c == ')') {
                while (!stack.isEmpty() && stack.peep() != '(') {
                    postfix.append(stack.pop());
                }
                stack.pop();
            }
            else {
                while (!stack.isEmpty() && prec(s.charAt(i)) >= prec(stack.peek()) || prec(s.charAt(i)) >= prec(stack.peek()) && associativity(s.charAt(i) == "P")) {
                    postfix.append(stack.pop());
                }
                stack.push(c);
            }
        }
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter the infix String without SPACES :");
        String infix = sc.nextLine();
    }
}
