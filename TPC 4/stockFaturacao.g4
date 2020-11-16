/* Gest�o de Stock e Fatura��o
 4.1 Defini��o Sint�tica
     Considere uma linguagem especifica para descrever Faturas.
     Sabe-se que uma Fatura � composta por um cabe�alho e um corpo, e este � composto por um ou mais movimentos.
     No cabe�alho deve aparecer o N�mero da Fatura, a Identifica��o do Fornecedor (nome, NIF, morada e NIB) e a
     Identifica��o do Cliente (nome, NIF, morada). Em cada linha do corpo da Fatura pretende-se, apenas incluir a
     Refer�ncia ao produto vendido e a Quantidade vendida.
     Para ser poss�vel processar as faturas convenientemente � necess�rio que no inicio de cada frase dessa linguagem surja
     uma descri��o do Stock, conjunto de produtos, sendo cada produto definido por: refer�ncia do produto, descri��o,
     pre�o unit�rio e quantidade em stock.
     Escreva ent�o uma Gram�tica Independente de Contexto, GIC, que especifique a Linguagem pretendida.
 4.2 Escreva uma Gram�tica de Atributos, GA, para calcular o total por linha e total geral, caso n�o sejam detetados erros
     sem�nticos (refer�ncias a produtos que n�o existem em Stock, ou venda de quantidades superiores �s existentes). Note
     que o seu processador deve atualizar o Stock de acordo com as vendas registadas em cada linha da fatura.
 */

grammar stockFaturacao;

@header{
        import java.util.*;
}

@members{
         class Produto{
                       String descricao;
                       Double precoUni;
                       Double nStock;
                       public String toString(){
                                                StringBuffer sb = new StringBuffer();
                                                sb.append(this.desc+"; ");
                                                sb.append(this.precU+"; ");
                                                sb.append(this.qtS+". ");
                                                return sb.toString();
                                               }
                      }         
}

faturas: stock fats[$stock.armazem]
       ;

fats [HashMap <String, Produto> armazem]
        :  f1 = fatura[$fats.armazem] {$fats.armazem = $f1.armazem;}
          (f2 = fatura[$fats.armazem] {$fats.armazem = $f2.armazem;})*
           {System.out.println("Quantidades armazenadas no fim: "); 
           System.out.println($f1.armazem.toString());} 
        ;

stock    returns[HashMap <String, Produto> armazem]
@init    { $stock.armazem = new HashMap<String, Produto>(); }
         : 'STOCK' 
            p1=produto[$stock.armazem] { $stock.armazem=$p1.armazemOut; }
           (p2=produto[$stock.armazem] { $stock.armazem=$p2.armazemOut; })*
         { System.out.println("Quantidades armazenadas no inicio: "); 
         System.out.println($stock.armazem.toString()); } 
         ;

produto  [HashMap <String, Produto> armazemIn]
         returns[HashMap<String, Produto> armazemOut]
         :  refProd ':' descProd ';' valUnit ';' quantStock
         {  Produto p = new Produto(); 
            p.descricao=$descProd.text; p.precoUni=Double.parseDouble($valUnit.text); p.nStock=Double.parseDouble($quantStock.text);
            $produto.armazemIn.put($refProd.text, p); 
            $produto.armazemOut=$produto.armazemIn;
         }
         ;

fatura   [HashMap <String, Produto> armazemIn]
         returns[HashMap<String, Produto> armazem]
         : 'FATURA' cabecalho 'VENDAS' corpo[$fatura.armazemIn]
         {  
            System.out.println("Total da Fatura: "+ $corpo.totF);
            $fatura.armazem = $corpo.armazem; 
         }
         ;

cabecalho: numFatura idFornecedor 'CLIENTE' idCliente
           {System.out.println("Fatura num: " + $numFatura.text);}
         ;

numFatura: ID;

idFornecedor: nome morada 'NIF: ' nif  'NIB: ' nib;

idCliente: nome morada 'NIF: ' nif;

nome: STR;

nif: STR;

morada: STR;

nib: STR;

corpo    [HashMap <String, Produto> armazemIn]
         returns[HashMap<String, Produto> armazem, Double totF]
@init    { System.out.println("Totais Parciais: "); }
         :  l1=linha[$corpo.armazemIn]  '.' { $corpo.totF = $l1.totL;  $corpo.armazem = $l1.armazem; }
           (l2=linha[$corpo.armazem] '.'    { $corpo.totF += $l2.totL; $corpo.armazem = $l2.armazem; })*
         ;

linha    [HashMap <String, Produto> armazemIn]
         returns[HashMap<String, Produto> armazem, Double totL]
         : refProd '|'  quant
         { Produto p;
                if ($linha.armazemIn.containsKey($refProd.text)) { 
                   p = $linha.armazemIn.get($refProd.text); 
                   System.out.println($refProd.text +": "+ (p.precoUni *(Double.parseDouble($quant.text))));
                   $linha.totL = (p.precoUni * (Double.parseDouble($quant.text))); 
                   p.nStock -= (Double.parseDouble($quant.text)); 
                   $linha.armazemIn.put($refProd.text,p);  
                 }
           else  { System.out.println("ERRO: A Referencia " + $refProd.text + " nao existe em Stock"); 
                   $linha.totL = 0.0; 
                 } 
           $linha.armazem = $linha.armazemIn;
         }
         ;

refProd: ID;

valUnit: NUM;

quant: NUM;

descProd: STR;

quantStock: NUM;

//Lexer
ID: ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_'|'-')*;
NUM: [0-9]+;
WS: ('\r'? '\n' | ' ' | '\t')+ -> skip;
STR:  '"' ( ESC_SEQ | ~('"') )* '"';
fragment ESC_SEQ:   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
                |   UNICODE_ESC
                |   OCTAL_ESC
                ;
fragment OCTAL_ESC:   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
                  |   '\\' ('0'..'7') ('0'..'7')
                  |   '\\' ('0'..'7')
                  ;
fragment UNICODE_ESC:   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment HEX_DIGIT: ('0'..'9'|'a'..'f'|'A'..'F');