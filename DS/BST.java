import java.util.Scanner;

class Node {
    int data;
    Node left;
    Node right;

    public Node(int data){
        this.data = data;
        left = right = null;
    }
}

public class BST {

    static Node root;
    
    public static Node arrayToBST(int[] arr, int start, int end){
        if (start > end)
            return null;
        int middle = (start + end) / 2;
        Node root = new Node(arr[middle]);

        root.left = arrayToBST(arr, start, middle - 1);
        root.right = arrayToBST(arr, middle + 1, end);

        return root;
    }

    public static void displayBST(Node node){
        if (node == null) 
            return;
        System.out.print(node.data + " ");
        displayBST(node.left);
        displayBST(node.right);
    }
    
    public static void main(String[] args) {
        @SuppressWarnings("resource")
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter Size of an Array : ");
        int n = sc.nextInt();

        int arr[] = new int[n];

        System.out.println("Enter Array Elements");
        for (int i = 0; i < n; i++) {
            System.out.print("At arr["+i+"] : ");
            arr[i] = sc.nextInt();
        }

        root = BST.arrayToBST(arr, 0, n - 1);

        System.out.println("Preorder traversal of Array is");
        BST.displayBST(root);
    }
}
