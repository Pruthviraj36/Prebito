import java.util.*;

class Graph {
    Map<Integer, List<Integer>> adjList;

    public Graph() {
        adjList = new HashMap<>();
    }

    public void addEdge(int u, int v) {
        adjList.putIfAbsent(u, new ArrayList<>());
        adjList.putIfAbsent(v, new ArrayList<>());
        adjList.get(u).add(v);
        adjList.get(v).add(u);
    }

    public void DFS(int start) {
        Set<Integer> visited = new HashSet<>();
        DFSHelper(start, visited);
    }

    private void DFSHelper(int vertex, Set<Integer> visited) {
        visited.add(vertex);
        System.out.print(vertex + " ");

        for (int neigh : adjList.getOrDefault(vertex, new ArrayList<>())) {
            if (!visited.contains(neigh)) {
                DFSHelper(neigh, visited);
            }
        }
    }

    public void BFS(int start) {
        Set<Integer> visited = new HashSet<>();
        Queue<Integer> queue = new LinkedList<>();
        queue.add(start);
        visited.add(start);

        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            System.out.print(vertex + " ");
            for (int neigh : adjList.getOrDefault(vertex, new ArrayList<>())) {
                if (!visited.contains(neigh)) {
                    queue.add(neigh);
                    visited.add(neigh);
                }
            }
        }
    }

    public void displayGraph() {
        System.out.println("Graph adjacency list:");
        for (Map.Entry<Integer, List<Integer>> entry : adjList.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
    }
}

public class L_16 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Graph g = new Graph();

        System.out.print("Enter number of edges: ");
        int n = sc.nextInt();
        System.out.println("Enter edges (u v):");

        for (int i = 0; i < n; i++) {
            int u = sc.nextInt();
            int v = sc.nextInt();

            System.out.println("Enter next pair");
            
            if (u != v) {  // Prevent self-loops
                g.addEdge(u, v);
            } else {
                System.out.println("Self-loops not allowed. Edge (" + u + ", " + v + ") ignored.");
            }
        }

        g.displayGraph();

        System.out.print("What do you want to do BFS[B]/DFS[D]? ");
        char choice = sc.next().charAt(0);
        if (choice != 'B' || choice != 'b' || choice != 'D' || choice != 'd') {
            System.out.println("Invalid choice! Please enter B for BFS or D for DFS.");
        }

        System.out.print("Enter starting vertex: ");
        int start = sc.nextInt();

        if (!g.adjList.containsKey(start)) {
            System.out.println("Starting vertex " + start + " does not exist in the graph.");
        } else {
            if (choice == 'B' || choice == 'b') {
                System.out.println("BFS starting from " + start + ": ");
                g.BFS(start);
            } else if (choice == 'D' || choice == 'd') {
                System.out.println("DFS starting from " + start + ": ");
                g.DFS(start);
            } else {
                System.out.println("Invalid choice! Please enter B for BFS or D for DFS.");
            }
        }

        sc.close();
    }
}
