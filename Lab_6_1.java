
import java.util.*;

 class Student{
    int id_no;
    int no_of_subjects_registered;
    int[] subject_code;
    int[] subject_credit;
    char[] grad_obtained;
    double spi;

    public Student() {
       Scanner sc = new Scanner(System.in);
       System.out.println("Enter the id no :"); 
       id_no = sc.nextInt();
       System.out.println("Enter the no of subjects registered :");
       no_of_subjects_registered = sc.nextInt();
       subject_code = new int[no_of_subjects_registered];
       subject_credit =  new int[no_of_subjects_registered];
       grad_obtained = new int[no_of_subjects_registered];

          for(int i=0; i<no_of_subjects_registered;i++) {

              System.out.println("Enter the subject code :");
              subject_code[i] = sc.nextInt();
              System.out.println("Enter the subject credit :");
              subject_credit[i] = sc.nextInt();
              System.out.println("Enter the grad obtained :");
              grad_obtained[i] = sc.next().charAt(0);


          }

    }

          public int calculate_spi(){
            //logic for calculating
            // it return nothin because the return type is void
            

            return 0;
          }

        public void  print_spi(double spi){


            System.out.println("SPI  is :"  +spi);
        }

 }

       

public class Lab_6_1 {
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the no of students :");
        int n = sc.nextInt();
        Student[] s1 = new Student[n];

        for(int j=0; j<n;j++) {
            s1[j] = new Student();
            s1.print_spi(spi);


        
    }
    
}
}
