import java.util.Scanner;
class Employee_Detail {
	int Employee_ID;
	String Name;
	String Designation;
	float Salary;

	public Employee_Detail(int empid, String name, String designation, float salary) {
	 	Employee_ID = empid;	
		Name = name;
		Designation = designation;
		Salary = salary;
	}
	public void display() {
		System.out.println(Employee_ID+Name+Designation+Salary);
	}
}
class L34 {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);

		System.out.println("Enter a Employee_ID");
		int empid = sc.nextInt();
		System.out.println("Enter a Name");
		String name = sc.nextLine();
		System.out.println("Enter a Designation");
		String designation = sc.nextLine();
		System.out.println("Enter a Salary");
		float salary = sc.nextFloat();

		Employee_Detail emp1 = new Employee_Detail(empid, name, designation, salary);
		emp1.display();
	}
}