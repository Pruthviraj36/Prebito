import java.util.Scanner;

class Node {
    int data;
    Node left, right;

    public Node(int data) {
        this.data = data;
        left = right = null;
    }
}

public class BST {

    static Node root;

    // Insert method for BST
    private static Node insertIntoBST(Node root, int value) {
        if (root == null) {
            root = new Node(value);
            return root;
        }
        if (value < root.data) root.left = insertIntoBST(root.left, value);
        else if (value > root.data) root.right = insertIntoBST(root.right, value);
        return root;
    }

    // Search method for BST
    private static boolean searchInBST(Node root, int value) {
        if (root == null) return false;
        else if (root.data == value) return true;
        else if (value < root.data) return searchInBST(root.left, value);
        else return searchInBST(root.right, value);
    }

    // Delete method for BST
    private static Node deleteFromBST(Node root, int value) {
        if (root == null) return root;
        else if (value < root.data) root.left = deleteFromBST(root.left, value);
        else if (value > root.data) root.right = deleteFromBST(root.right, value); 
        else {
            // Node to be deleted found

            // Case 1: No child
            if (root.left == null && root.right == null) return null;

            // Case 2: One child
            if (root.left == null) return root.right;
            else if (root.right == null) return root.left;

            // Case 3: Two children
            Node inorderSuccessor = findMin(root.right);
            root.data = inorderSuccessor.data;
            root.right = deleteFromBST(root.right, inorderSuccessor.data);
        }
        return root;
    }

    // Helper method to find the minimum node (in-order successor)
    private static Node findMin(Node root) {
        while (root.left != null) {
            root = root.left;
        }
        return root;
    }

    // Helper method to find the maximum node
    private static Node findMax(Node root) {
        while (root.right != null) {
            root = root.right;
        }
        return root;
    }

    // Preorder traversal
    private static void preorderTraversal(Node node) {
        if (node == null) return;
        System.out.print(node.data + " ");
        preorderTraversal(node.left);
        preorderTraversal(node.right);
    }

    // Insert array of elements into BST
    private static void insertArrayIntoBST(int[] arr) {
        for (int value : arr) {
            root = insertIntoBST(root, value);
        }
    }

    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            int choice, value;

            do {
                System.out.println("\n--- Menu ---");
                System.out.println("1. Insert Array");
                System.out.println("2. Search");
                System.out.println("3. Delete");
                System.out.println("4. Preorder Traversal");
                System.out.println("5. Find Minimum Node");
                System.out.println("6. Find Maximum Node");
                System.out.println("7. Exit");
                System.out.print("Enter your choice: ");
                choice = sc.nextInt();

                switch (choice) {
                    case 1 -> {
                        System.out.print("Enter Size of the Array: ");
                        int n = sc.nextInt();

                        int[] arr = new int[n];

                        System.out.println("Enter Array Elements:");
                        for (int i = 0; i < n; i++) {
                            System.out.print("At arr[" + i + "]: ");
                            arr[i] = sc.nextInt();
                        }

                        insertArrayIntoBST(arr);
                        System.out.println("Array elements inserted into the BST.");
                    }

                    case 2 -> {
                        System.out.print("Enter value to search: ");
                        value = sc.nextInt();
                        if (searchInBST(root, value)) {
                            System.out.println("\n" + value + " found.");
                        } else {
                            System.out.println("\n" + value + " not found.");
                        }
                    }

                    case 3 -> {
                        System.out.print("Enter value to delete: ");
                        value = sc.nextInt();
                        root = deleteFromBST(root, value);
                        System.out.println("Value deleted.");
                    }

                    case 4 -> {
                        System.out.println("Preorder traversal of the BST:");
                        preorderTraversal(root);
                        System.out.println();
                    }

                    case 5 -> {
                        Node minNode = findMin(root);
                        if (minNode != null) {
                            System.out.println("Minimum Node of the BST: " + minNode.data);
                        } else {
                            System.out.println("BST is empty.");
                        }
                    }

                    case 6 -> {
                        Node maxNode = findMax(root);
                        if (maxNode != null) {
                            System.out.println("Maximum Node of the BST: " + maxNode.data);
                        } else {
                            System.out.println("BST is empty.");
                        }
                    }

                    case 7 -> System.out.println("Exiting...");

                    default -> System.out.println("Invalid choice! Please choose again.");
                }
            } while (choice != 7);
        }
    }
}
