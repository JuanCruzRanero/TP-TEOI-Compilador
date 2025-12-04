package analizadorLexico;
import java_cup.runtime.*;
import java.io.*;
import java.util.*;

%%

%cup
%public
%class Lexico
%line
%column
%char

%{
    public List<String[]> tabla_de_simbolos = new ArrayList<>();

    void guardarTablaSimbolos() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter("tabla_de_simbolos.txt"))) {
            writer.write(String.format("%-30s %-12s %-12s %-20s %-8s",
                "Nombre", "Token", "Tipo", "Valor", "Long"));
            writer.newLine();
            writer.write("------------------------------------------------------------------------------");
            writer.newLine();

            for (String[] simbolo : tabla_de_simbolos) {
                writer.write(String.format("%-30s %-12s %-12s %-20s %-8s",
                    simbolo[0], simbolo[1], simbolo[2], simbolo[3], simbolo[4]));
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public void setTipo(String nombre, String tipo) {
        for (String[] simbolo : tabla_de_simbolos) {
            if (simbolo[0].equals(nombre) && simbolo[1].equals("ID")) {
                simbolo[2] = tipo;
                guardarTablaSimbolos();
                return;
            }
        }
        // Si no existe, agregarlo
        String[] nuevo = {nombre, "ID", tipo, "_", "_"};
        tabla_de_simbolos.add(nuevo);
        guardarTablaSimbolos();
    }
%}

digito = [0-9]
letra  = [a-zA-Z]
espacio = [ \t\f\n\r]+

ID        = {letra}({letra}|{digito})*
CTE_STR   = \"[^\"]{0,30}\"      // Máximo 30 caracteres
CTE_F     = (({digito}+"."{digito}*) | ("."{digito}+) | ({digito}+"."{digito}+))
CTE_E     = {digito}+
CTE_B     = "0b"[01]+
CTE_H     = "0h"[0-9a-fA-F]+
COMENTARIO = ("//"[^\n]*)|("\$\*"([^*]|\*+[^$])*"\*\$")

%%

<YYINITIAL> {
    // PALABRAS RESERVADAS
    "IF"                     { return new Symbol(sym.IF, yytext()); }
    "ELSE"                   { return new Symbol(sym.ELSE, yytext()); }
    "THEN"                   { return new Symbol(sym.THEN, yytext()); }
    "WHILE"                  { return new Symbol(sym.WHILE, yytext()); }
    "DECVAR"                 { return new Symbol(sym.DECVAR, yytext()); }
    "ENDDECVAR"              { return new Symbol(sym.ENDDECVAR, yytext()); }
    "PROGRAM_SECTION"        { return new Symbol(sym.PROGRAM_SECTION, yytext()); }
    "ENDPROGRAM_SECTION"     { return new Symbol(sym.ENDPROGRAM_SECTION, yytext()); }
    "REPEAT"                 { return new Symbol(sym.REPEAT, yytext()); }
    "STRVAR"                 { return new Symbol(sym.STRVAR, yytext()); }
    "NUMVAR"                 { return new Symbol(sym.NUMVAR, yytext()); }
    "SHOW"                   { return new Symbol(sym.SHOW, yytext()); }
    "STRING"                 { return new Symbol(sym.STRING, yytext()); }
    "INTEGER"                { return new Symbol(sym.INTEGER, yytext()); }
    "DOUBLE"                 { return new Symbol(sym.DOUBLE, yytext()); }
    "BEGIN"                  { return new Symbol(sym.BEGIN, yytext()); }
    "END"                    { return new Symbol(sym.END, yytext()); }

    // OPERADORES
    "+"                      { return new Symbol(sym.OP_SUMA, yytext()); }
    "-"                      { return new Symbol(sym.OP_RESTA, yytext()); }
    "*"                      { return new Symbol(sym.OP_MULTI, yytext()); }
    "/"                      { return new Symbol(sym.OP_DIV, yytext()); }
    "&&"                     { return new Symbol(sym.OPL_AND, yytext()); }
    "||"                     { return new Symbol(sym.OPL_OR, yytext()); }
    "!"                      { return new Symbol(sym.OPL_NOT, yytext()); }
    "!="                     { return new Symbol(sym.OP_DIST, yytext()); }
    "="                      { return new Symbol(sym.OP_IGUAL, yytext()); }
    "<"                      { return new Symbol(sym.OP_MENOR, yytext()); }
    ">"                      { return new Symbol(sym.OP_MAYOR, yytext()); }
    ">="                     { return new Symbol(sym.OP_MAYOR_IG, yytext()); }
    "<="                     { return new Symbol(sym.OP_MENOR_IG, yytext()); }
    "::="                    { return new Symbol(sym.OP_ASIGNACION, yytext()); }
    ":="                     { return new Symbol(sym.OP_DECLARACION, yytext()); }
    "?"                      { return new Symbol(sym.IF_UNARIO, yytext()); }

    // SÍMBOLOS
    "("                      { return new Symbol(sym.A_PARENT, yytext()); }
    ")"                      { return new Symbol(sym.C_PARENT, yytext()); }
    "{"                      { return new Symbol(sym.A_LLAVE, yytext()); }
    "}"                      { return new Symbol(sym.C_LLAVE, yytext()); }
    ";"                      { return new Symbol(sym.P_Y_C, yytext()); }
    ","                      { return new Symbol(sym.COMA, yytext()); }

    // IDENTIFICADORES
    {ID} {
        String id = yytext();
        boolean existe = false;
        for (String[] simbolo : tabla_de_simbolos) {
            if (simbolo[0].equals(id) && simbolo[1].equals("ID")) {
                existe = true;
                break;
            }
        }
        if (!existe) {
            String[] simbolo = {id, "ID", "_", "_", "_"};
            tabla_de_simbolos.add(simbolo);
            guardarTablaSimbolos();
        }
        return new Symbol(sym.ID, yytext());
    }

    // CONSTANTES
    {CTE_B} {
        String[] simbolo = {yytext(), "CTE_B", "_", yytext(), "_"};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        return new Symbol(sym.CTE_B, yytext());
    }

    {CTE_H} {
        String[] simbolo = {yytext(), "CTE_H", "_", yytext(), "_"};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        return new Symbol(sym.CTE_H, yytext());
    }

    {CTE_F} {
        String[] simbolo = {yytext(), "CTE_F", "_", yytext(), "_"};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        return new Symbol(sym.CTE_F, yytext());
    }

    {CTE_E} {
        String[] simbolo = {yytext(), "CTE_E", "_", yytext(), "_"};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        return new Symbol(sym.CTE_E, yytext());
    }

    {CTE_STR} {
        String texto = yytext();
        String valor = texto.substring(1, texto.length() - 1); // Quitar comillas
        String[] simbolo = {valor, "CTE_STR", "_", valor, String.valueOf(valor.length())};
        tabla_de_simbolos.add(simbolo);
        guardarTablaSimbolos();
        return new Symbol(sym.CTE_STR, yytext());
    }

    // IGNORAR
    {COMENTARIO}             { /* ignorar comentarios */ }
    {espacio}                { /* ignorar espacios */ }

    // ERROR
    [^]                      {
        throw new Error("Caracter no permitido: '" + yytext() + "' en línea " + (yyline + 1));
    }
}