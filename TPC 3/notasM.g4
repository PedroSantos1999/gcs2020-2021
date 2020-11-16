/* Notas M�dias dos alunos de uma turma
 2.1 Defini��o Sint�tica
     Desenvolva uma GIC para definir uma linguagem que permita descrever os alunos (identificados pelo seu nome) de
     uma turma especifica, de tal forma que a frase abaixo seja uma frase v�lida dessa linguagem.
 2.2 Defini��o Sem�ntica
     Transforme a GIC numa GA de modo resolver os seguintes pedidos
        a) contar o total de alunos
        b) calcular a nota m�dia de cada aluno
        c) garantir que todos os alunos t�m entre 4 e 6 notas e que estas est�o na escala '0' a '20'
        d) garantir que n�o h� nomes repetidos
 */

grammar notasM;

turmas: turma+;

turma: TURMA ID
       alunos{
               System.out.println("Total Alunos: " + $alunos.totalAlunos);
             }
       PONTO;

alunos returns [int totalAlunos]:
        aluno      {$totalAlunos = 1;}
        (
        PONTOVIRGULA aluno {$totalAlunos +=1;}
        )*;

aluno: nome notas[$nome.text] {
                   float media = $notas.soma / $notas.totalNotas;
                   System.out.println("A m�dia do/a " + $nome.text + " � " + media);
                   }
    ;

nome: NOME
    ;

notas[String nomeAluno] returns [int soma, int totalNotas]: 
     LP n1=NUM {$soma = $n1.int; $totalNotas = 1;
                if (!($n1.int > 0 && $n1.int < 20))
                System.out.println("Nota OUT OF RANGE");
                }
     (VIRGULA n2=NUM {$soma += $n2.int; 
                      if (!($n2.int > 0 && $n2.int < 20))
                      System.out.println("Nota OUT OF RANGE");
                      $totalNotas += 1;}
     )* RP           {if ($totalNotas < 4)
                      System.out.println("ERROR: O Aluno " + $nomeAluno + " tem notas a menos");
                      if ($totalNotas > 6)
                      System.out.println("ERROR: O Aluno " + $nomeAluno + " tem notas a mais");}
     ; 

//Lexer
TURMA: [tT][uU][rR][mM][aA];
ID: [a-zA-Z]+;
NOME: [a-zA-Z]+;
NUM: [0-9]+;
VIRGULA: ',';
PONTOVIRGULA: ';';
PONTO: '.';
LP: '(';
RP: ')';
WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;