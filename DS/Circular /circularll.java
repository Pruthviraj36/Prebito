import java.util.*;
public class CircularLL{

	static class Node{
		int info;
		Node link;

		public Node(int data){
			info = data;
			link = null;
		}
	}
	static Node first = null;
	static Node last = null;

	public static void insertAtFirst(int n){
		Node newNode = new Node(n);
		if (first == null) {
			System.out.println("LinkedList is Empty First Node inserted");
			first = newNode;
			first.link = first;
			last = first;
			return;
		}
		else {
			Node save = first;
            while (save.link!= first) {
                save = save.link;
            }
            save.link = newNode;
            newNode.link = first;
            first = newNode;
		}
	}

	public static void display() {
		Node save = first;
		do {
			System.out.print(save.info+" ");
			save = save.link;
		} while (save!= first);
	}

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int operator = 0;
        System.out.println("\nEnter 1 to insertAtFirst");
        System.out.println("Enter 2 to display");
        System.out.println("Enter 7 to stop\n");

        while (operator != 7) {
        	operator = sc.nextInt();
        
	        if (operator == 1) {
	        	System.out.print("Enter value : ");
	        	int val = sc.nextInt();
	        	insertAtFirst(val);
	        }
	        else if (operator == 2) {
	        	display();
	        }
	        else if (operator == 7) {
	        	return;
	        }
        }
    }
}
