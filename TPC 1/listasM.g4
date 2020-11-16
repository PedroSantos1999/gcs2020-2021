/* Listas Mistas sens�veis ao contexto
 1.1 Defini��o Sint�tica
     Desenvolva uma GIC para definir uma linguagem que permita escrever listas mistas de n�meros e palavras, de tal
     forma que as 3 frases abaixo sejam frases v�lidas dessa linguagem.
 1.2 Defini��o Sem�ntica
     Transforme a GIC numa GA de modo calcular os resultados pedidos nas alineas seguintes. Comece por definir uma
     GT recorrendo a vari�veis globais e a��es sem�nticas para resolver a alinea a).
        a) contar o comprimento da lista e a quantidade de n�meros
        b) acrescente aos resultados anteriores a m�dia de todos os n�meros que apare�am na lista.
        c) obrigar a que quantidade de palavras seja igual a quantidade de n�meros.
        d) calcular o m�ximo dos n�meros.
        e) calcular o somat�rio apenas dos n�meros contidos entre 'start' e 'stop'.
 */

grammar listasM;

@members {
    int contador = 1;
    int comprimento = 0;
    int nNumeros = 0;
    int somaNumeros = 0;
    float media = 0;
    int nPalavras = 0;
    int max = 0;
    boolean contido = false;
    int somaContida = 0;
}

listas: lista+;

lista: LISTA elementos '.'                       {System.out.println("***---Lista Mista " + contador + " ---***");
                                                  System.out.println("a) Comprimento da lista: " + comprimento);
                                                  System.out.println("a) Quantidade de numeros: " + nNumeros );
                                                  if (nNumeros > 0) media = (float) somaNumeros / nNumeros ;
                                                  System.out.println("b) Media de todos os numeros da lista: " + (float) media);
                                                  if (nNumeros == nPalavras) System.out.println("c) Quantidade de palavras e igual a quantidade de numeros.");
                                                  else System.out.println("c) Quantidade de palavras: " + nPalavras + ", nao e igual a quantidade de numeros: " + qtNumeros + ".");
                                                  System.out.println("d) Maximo dos numeros: " + max);
                                                  System.out.println("e) Somatorio apenas dos numeros contidos entre 'start' e 'stop': " + somaContida);
                                                  System.out.println("-------------------------------------------");
                                                  contador++;
                                                  qtNumeros = 0;
                                                  somaNumeros = 0;
                                                  media = 0;
                                                  qtPalavras = 0;
                                                  maximo = 0;
                                                  contido = false;
                                                  somaContida = 0;
                                                 }
     ;

elementos: elemento                              {comprimento=1;} ( ',' elemento { comprimento++; } )*
         ;

elemento: PALAVRA                                {nPalavras++;
                                                  if($PALAVRA.text.equals("agora")) contido = true;
                                                  if($PALAVRA.text.equals("fim")) contido = false;
                                                 }
        | NUM                                    {nNumeros++;
                                                  somaNumeros += $NUM.int;
                                                  if(max < $NUM.int) max = $NUM.int;
                                                  if(contido) somaContida += $NUM.int;
                                                 }
        ;

//Lexer
LISTA: [lL][iI][sS][tT][aA];
NUM: ('0'..'9')+; //[0-9]+
PALAVRA: [a-zA-Z][a-zA-Z0-9]*;
WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;