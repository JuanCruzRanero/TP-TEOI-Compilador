package org.example;
import java_cup.runtime.*;
import java.util.*;

%%

%cup
%public
%class Lexico
%line
%column
%char

// Alfabetos

digito = [0-9]
letra  = [a-zA-Z]
espacio = [ \t\f\n\r]+


// Expresiones regulares

ID        = {letra}({letra}|{digito})*
CTE_STR   = \"([a-zA-Z0-9 ]{0,30})\"
CTE_F     = (({digito}+ "." {digito}*) | ("." {digito}+) | ({digito}+ "." {digito}+))
CTE_E     = {digito}+
CTE_B     = "0b"(0|1)+
CTE_H     = "0h"([0-9a-fA-F])+
COMENTARIO   = "\$\*"([^*]|\*+[^$])*"\*\$"
COMENT_JAVA  = "/*" ~ "*/"

// sector de codigo java que podemos agregar nosotros

%{
    List<String[]> tabla_de_simbolos = new ArrayList<>();

void guardarTablaSimbolos() {
    try (BufferedWriter writer = new BufferedWriter(new FileWriter("tabla_de_simbolos.txt"))) {
        // Columnas
        writer.write(String.format("%-50s %-15s %-20s %-50s %-5s", "Nombre", "Token", "Tipo", "Valor", "Long"));
        writer.newLine();
        writer.write("--------------------------------------------------------------------------------------------------------------------------------------------------------");
        writer.newLine();

        // Filas
        for (String[] simbolo : tabla_de_simbolos) {
            writer.write(String.format("%-50s %-15s %-20s %-50s %-5s", simbolo[0], simbolo[1], simbolo[2], simbolo[3], simbolo[4]));
            writer.newLine();
        }

    } catch (IOException e) {
        System.err.println("Error al escribir la tabla de símbolos en el archivo: " + e.getMessage());
    }
}
%}

%%

<YYINITIAL> {

"IF"                         { VentanaPrincipal.je.append("Token IF encontrado, Lexema "+yytext()+"\n"); }
"ELSE"                       { VentanaPrincipal.je.append("Token ELSE encontrado, Lexema "+yytext()+"\n"); }
"THEN"                       { VentanaPrincipal.je.append("Token THEN encontrado, Lexema "+yytext()+"\n"); }
"WHILE"                      { VentanaPrincipal.je.append("Token WHILE encontrado, Lexema "+yytext()+"\n"); }
"CONST"                      { VentanaPrincipal.je.append("Token CONST encontrado, Lexema "+yytext()+"\n"); }
"DECVAR"                     { VentanaPrincipal.je.append("Token DECVAR encontrado, Lexema "+yytext()+"\n"); }
"ENDDECVAR"                  { VentanaPrincipal.je.append("Token ENDDECVAR encontrado, Lexema "+yytext()+"\n"); }
"PROGRAM.SECTION"            { VentanaPrincipal.je.append("Token PROGRAM.SECTION encontrado, Lexema "+yytext()+"\n"); }
"ENDPROGRAM.SECTION"         { VentanaPrincipal.je.append("Token ENDPROGRAM.SECTION encontrado, Lexema "+yytext()+"\n"); }
"WRITE"                      { VentanaPrincipal.je.append("Token WRITE encontrado, Lexema "+yytext()+"\n"); }
"REPEAT"                     { VentanaPrincipal.je.append("Token REPEAT encontrado, Lexema "+yytext()+"\n"); }
"STRVAR"                     { VentanaPrincipal.je.append("Token STRVAR encontrado, Lexema "+yytext()+"\n"); }
"NUMVAR"                     { VentanaPrincipal.je.append("Token NUMVAR encontrado, Lexema "+yytext()+"\n"); }
"SHOW"                       { VentanaPrincipal.je.append("Token SHOW encontrado, Lexema "+yytext()+"\n"); }
"STRING"                     { VentanaPrincipal.je.append("Token STRING encontrado, Lexema "+yytext()+"\n"); }
"INTEGER"                    { VentanaPrincipal.je.append("Token INTEGER encontrado, Lexema "+yytext()+"\n"); }
"DOUBLE"                     { VentanaPrincipal.je.append("Token DOUBLE encontrado, Lexema "+yytext()+"\n"); }

"+"                          { VentanaPrincipal.je.append("Token OP_SUMA encontrado, Lexema "+yytext()+"\n"); }
"-"                          { VentanaPrincipal.je.append("Token OP_RESTA encontrado, Lexema "+yytext()+"\n"); }
"*"                          { VentanaPrincipal.je.append("Token OP_MULTI encontrado, Lexema "+yytext()+"\n"); }
"/"                          { VentanaPrincipal.je.append("Token OP_DIV encontrado, Lexema "+yytext()+"\n"); }

"&&"                         { VentanaPrincipal.je.append("Token OPL_AND encontrado, Lexema "+yytext()+"\n"); }
"||"                         { VentanaPrincipal.je.append("Token OPL_OR encontrado, Lexema "+yytext()+"\n"); }
"!"                          { VentanaPrincipal.je.append("Token OPL_NOT encontrado, Lexema "+yytext()+"\n"); }
"!="                         { VentanaPrincipal.je.append("Token OP_DIST encontrado, Lexema "+yytext()+"\n"); }
"=="                         { VentanaPrincipal.je.append("Token OP_IGUAL encontrado, Lexema "+yytext()+"\n"); }
"<"                          { VentanaPrincipal.je.append("Token OP_MENOR encontrado, Lexema "+yytext()+"\n"); }
">"                          { VentanaPrincipal.je.append("Token OP_MAYOR encontrado, Lexema "+yytext()+"\n"); }
">="                         { VentanaPrincipal.je.append("Token OP_MAYOR_IG encontrado, Lexema "+yytext()+"\n"); }
"<="                         { VentanaPrincipal.je.append("Token OP_MENOR_IG encontrado, Lexema "+yytext()+"\n"); }
"::="                        { VentanaPrincipal.je.append("Token OP_ASIGNACION encontrado, Lexema "+yytext()+"\n"); }
":="                         { VentanaPrincipal.je.append("Token OP_DECLARACION encontrado, Lexema "+yytext()+"\n"); }
"?"                          { VentanaPrincipal.je.append("Token IF_UNARIO encontrado, Lexema "+yytext()+"\n"); }

"("                          { VentanaPrincipal.je.append("Token A_PARENT encontrado, Lexema "+yytext()+"\n"); }
")"                          { VentanaPrincipal.je.append("Token C_PARENT encontrado, Lexema "+yytext()+"\n"); }
"{"                          { VentanaPrincipal.je.append("Token A_LLAVE encontrado, Lexema "+yytext()+"\n"); }
"}"                          { VentanaPrincipal.je.append("Token C_LLAVE encontrado, Lexema "+yytext()+"\n"); }
";"                          { VentanaPrincipal.je.append("Token P_Y_C encontrado, Lexema "+yytext()+"\n"); }

{ID} {
    // Actualizacion de la tabla de simbolo al encontrar el token ID
    String id = yytext();
    boolean existe = false;

    for (String[] simbolo : tabla_de_simbolos) {
        if (simbolo[0].equals(id)) {
            existe = true;
            break;
        }
    }

    if (!existe) {
        // agregar la ID en la tabla de simbolo
        String[] simbolo = {id, "ID", "_", "_", "_"};
        tabla_de_simbolos.add(simbolo);
    }
    guardarTablaSimbolos();
    VentanaPrincipal.je.append("Token ID encontrado, Lexema "+yytext()+"\n");
}

{CTE_B}                  {VentanaPrincipal.je.append("Token CTE_B encontrado, Lexema "+yytext()+"\n");}

{CTE_H}                  {VentanaPrincipal.je.append("Token CTE_H encontrado, Lexema "+yytext()+"\n");}

{CTE_F} {
    // control del tamaño del float
    float valor = Float.parseFloat(yytext());
    if (valor < -3.4028235E38 || valor > 3.4028235E38) {
        throw new Error("Caracter inválido: <" + yytext() + "> en la linea " + yyline + " excede el limite de tamaño");
    } else {
        // agregar la constante float en la tabla de simbolo
        String[] simbolo = {"_" + yytext(), "CTE_F", "_", yytext(), "_"};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        VentanaPrincipal.je.append("Token CTE_F encontrado, Lexema "+yytext()+"\n");
    }
}

{CTE_E} {
    // control del tamaño del valor del entero y su cantidad de digitos
    String largo = String.valueOf(yytext());
    int valor = Integer.parseInt(yytext());
    if (valor < -32768 || valor > 32767 || largo.length() > 10)  {
        throw new Error("Caracter inválido: <" + yytext() + "> en la linea " + yyline + " excede el limite de tamaño");
    } else {
        // agregar la constante INT en la tabla de simbolo
        String[] simbolo = {"_" + yytext(), "CTE_E", "_", yytext(), "_"};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        VentanaPrincipal.je.append("Token CTE_E encontrado, Lexema "+yytext()+"\n");
    }
}

{CTE_STR} {
    // control de la longitud del string
    String value = yytext();
    if (value.length() > 32) {
        throw new Error("Caracter inválido: <" + yytext() + "> en la linea " + yyline + " excede el limite de caracteres");
    } else {
        // agregar la constante string en la tabla de simbolo
        String[] simbolo = {"_" + yytext(), "CTE_STR", "_", yytext(), String.valueOf(value.length())};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        VentanaPrincipal.je.append("Token CTE_STR encontrado, Lexema "+yytext()+"\n");
    }
}

    {espacio} { /* ignorar espacios */ }
    {COMENTARIO} { /* ignorar comentario tipo $* *$ */ }
    {COMENT_JAVA} { /* ignorar comentario tipo /* */ }

    [^] { throw new Error("Caracter no permitido: <" + yytext() + "> en la línea " + yyline); }

}
