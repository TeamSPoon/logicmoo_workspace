/* Generated By:JJTree&JavaCC: Do not edit this line. CanonicalTermParser.java */
package org.cs3.prolog.connector.internal.cterm.parser;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("javadoc")
public class CanonicalTermParser/*@bgen(jjtree)*/implements CanonicalTermParserTreeConstants, CanonicalTermParserConstants {/*@bgen(jjtree)*/
  protected JJTCanonicalTermParserState jjtree = new JJTCanonicalTermParserState();public static class RuntimeException extends java.lang.RuntimeException{

                        /**
	 * 
	 */
	private static final long serialVersionUID = 2132793322254995847L;
						private Throwable cause;
                        private String message;

                        public RuntimeException(Throwable e) {
                                this.cause = e;
                                message="wrapped exception";
                        }

                        public RuntimeException(String message,Throwable e) {
                                this.cause = e;
                                this.message = message;
                        }

                        @Override
						public Throwable fillInStackTrace() {
                                return cause.fillInStackTrace();
                        }

                        @Override
						public String getLocalizedMessage() {
                                return message + " ("+cause.getLocalizedMessage()+")";
                        }

                        @Override
						public String getMessage() {
                                return message + " ("+cause.getMessage()+")";
                        }

                        @Override
						public void printStackTrace() {
                                cause.printStackTrace();
                        }

                        @Override
						public void printStackTrace(PrintStream arg0) {
                                cause.printStackTrace(arg0);
                        }

                        @Override
						public void printStackTrace(PrintWriter arg0) {
                                cause.printStackTrace(arg0);
                        }

                        @Override
						public String toString() {
                                return cause.toString();
                        }

            }

        private List<ParseException> errors = new ArrayList<ParseException>();

        public List<ParseException> getErrors() {
                return errors;
        }

                void jjtreeOpenNodeScope(Node n)
    {
        Token t = getToken(1);

      ((SimpleNode)n).jjtSetFirstToken(t);

    }

    void jjtreeCloseNodeScope(Node n)
    {
      Token t = getToken(0);
      ((SimpleNode)n).jjtSetLastToken(t);



                //need to "manualy" figure out the start token, as node scope hooks are
                //called "to late" for nodes like ASTInfixTerm 
                //if the nodes children have already been poped, this should work:
                SimpleNode s = (SimpleNode)n;
                if(s.jjtGetNumChildren()>0){
                         SimpleNode firstChild = (SimpleNode)s.jjtGetChild(0);
                         s.jjtSetFirstToken(firstChild.jjtGetFirstToken());
                }



          }


        public void error_skipto(int kind) {
          ParseException e = generateParseException();
          errors.add(e);
          Token t;
          do {
            t = getNextToken();
          } while (t.kind != kind && t.kind != EOF);
        }

public static void main(String args[]) throws FileNotFoundException {
        InputStream stream = null;
        if(args==null||args.length==0){
             stream=System.in;
        }
        else{
                return;
        }
    CanonicalTermParser t = new CanonicalTermParser(stream);
    try {
      t.Term();

      System.err.println("Thank you.");
    } catch (Exception e) {
      System.err.println("Oops.");
      System.err.println(e.getMessage());
      e.printStackTrace();
    }
  }
  public Node getASTRoot(){
                return  jjtree.rootNode();
        }

  final public void Start() throws ParseException {
    Term();
    jj_consume_token(0);
  }

  final public void Term() throws ParseException {
    if (jj_2_1(2147483647)) {
      jj_consume_token(LPAREN);
      Term();
      jj_consume_token(RPAREN);
    } else if (jj_2_2(2147483647)) {
      Atom();
    } else if (jj_2_3(2147483647)) {
      Compound();
    } else {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case QUOTED_STRING:
        String();
        break;
      case LBRC:
      case CUT:
      case CLAUSE_DEF:
      case ATOM_IDENTIFIER:
      case QUOTED_ATOM:
        Atom();
        break;
      case DECIMAL_LITERAL:
      case BIN_LITERAL:
      case FLOATING_POINT_LITERAL:
        Number();
        break;
      case LSQB:
        Nil();
        break;
      case VARIABLE_IDENTIFIER:
        Variable();
        break;
      default:
        jj_la1[0] = jj_gen;
        jj_consume_token(-1);
        throw new ParseException();
      }
    }
  }

  final public void ClauseSyntax() throws ParseException {
    jj_consume_token(CLAUSE_DEF);
    jj_consume_token(LPAREN);
    jj_consume_token(CLAUSE_REFERENCE);
    jj_consume_token(RPAREN);
  }

  final public void Atom() throws ParseException {
             /*@bgen(jjtree) Atom */
  ASTAtom jjtn000 = new ASTAtom(this, JJTATOM);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case CLAUSE_DEF:
        ClauseSyntax();
        break;
      case ATOM_IDENTIFIER:
        jj_consume_token(ATOM_IDENTIFIER);
        break;
      case QUOTED_ATOM:
        jj_consume_token(QUOTED_ATOM);
        break;
      case CUT:
        jj_consume_token(CUT);
        break;
      case LBRC:
        jj_consume_token(LBRC);
        jj_consume_token(RBRC);
        break;
      default:
        jj_la1[1] = jj_gen;
        jj_consume_token(-1);
        throw new ParseException();
      }
    } catch (Throwable jjte000) {
          if (jjtc000) {
            jjtree.clearNodeScope(jjtn000);
            jjtc000 = false;
          } else {
            jjtree.popNode();
          }
          if (jjte000 instanceof RuntimeException) {
            {if (true) throw (RuntimeException)jjte000;}
          }
          if (jjte000 instanceof ParseException) {
            {if (true) throw (ParseException)jjte000;}
          }
          {if (true) throw (Error)jjte000;}
    } finally {
          if (jjtc000) {
            jjtree.closeNodeScope(jjtn000, true);
            jjtreeCloseNodeScope(jjtn000);
            jjtn000.jjtSetLastToken(getToken(0));
          }
    }
  }

  final public void Nil() throws ParseException {
            /*@bgen(jjtree) Nil */
  ASTNil jjtn000 = new ASTNil(this, JJTNIL);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      jj_consume_token(LSQB);
      jj_consume_token(RSQB);
    } finally {
          if (jjtc000) {
            jjtree.closeNodeScope(jjtn000, true);
            jjtreeCloseNodeScope(jjtn000);
            jjtn000.jjtSetLastToken(getToken(0));
          }
    }
  }

  final public void Variable() throws ParseException {
                 /*@bgen(jjtree) Variable */
  ASTVariable jjtn000 = new ASTVariable(this, JJTVARIABLE);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      jj_consume_token(VARIABLE_IDENTIFIER);
    } finally {
          if (jjtc000) {
            jjtree.closeNodeScope(jjtn000, true);
            jjtreeCloseNodeScope(jjtn000);
            jjtn000.jjtSetLastToken(getToken(0));
          }
    }
  }

  final public void Compound() throws ParseException {
                 /*@bgen(jjtree) Compound */
  ASTCompound jjtn000 = new ASTCompound(this, JJTCOMPOUND);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      Atom();
      jj_consume_token(LPAREN);
      Term();
      label_1:
      while (true) {
        switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
        case COMMA:
          ;
          break;
        default:
          jj_la1[2] = jj_gen;
          break label_1;
        }
        jj_consume_token(COMMA);
        Term();
      }
      jj_consume_token(RPAREN);
    } catch (Throwable jjte000) {
          if (jjtc000) {
            jjtree.clearNodeScope(jjtn000);
            jjtc000 = false;
          } else {
            jjtree.popNode();
          }
          if (jjte000 instanceof RuntimeException) {
            {if (true) throw (RuntimeException)jjte000;}
          }
          if (jjte000 instanceof ParseException) {
            {if (true) throw (ParseException)jjte000;}
          }
          {if (true) throw (Error)jjte000;}
    } finally {
          if (jjtc000) {
            jjtree.closeNodeScope(jjtn000, true);
            jjtreeCloseNodeScope(jjtn000);
            jjtn000.jjtSetLastToken(getToken(0));
          }
    }
  }

  final public void Number() throws ParseException {
    switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
    case DECIMAL_LITERAL:
    case BIN_LITERAL:
      Integer();
      break;
    case FLOATING_POINT_LITERAL:
      Float();
      break;
    default:
      jj_la1[3] = jj_gen;
      jj_consume_token(-1);
      throw new ParseException();
    }
  }

  final public void Integer() throws ParseException {
                  /*@bgen(jjtree) Integer */
  ASTInteger jjtn000 = new ASTInteger(this, JJTINTEGER);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      switch ((jj_ntk==-1)?jj_ntk():jj_ntk) {
      case DECIMAL_LITERAL:
        jj_consume_token(DECIMAL_LITERAL);
        break;
      case BIN_LITERAL:
        jj_consume_token(BIN_LITERAL);
        break;
      default:
        jj_la1[4] = jj_gen;
        jj_consume_token(-1);
        throw new ParseException();
      }
    } finally {
    if (jjtc000) {
      jjtree.closeNodeScope(jjtn000, true);
      jjtreeCloseNodeScope(jjtn000);
      jjtn000.jjtSetLastToken(getToken(0));
    }
    }
  }

  final public void Float() throws ParseException {
               /*@bgen(jjtree) Float */
  ASTFloat jjtn000 = new ASTFloat(this, JJTFLOAT);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      jj_consume_token(FLOATING_POINT_LITERAL);
    } finally {
          if (jjtc000) {
            jjtree.closeNodeScope(jjtn000, true);
            jjtreeCloseNodeScope(jjtn000);
            jjtn000.jjtSetLastToken(getToken(0));
          }
    }
  }

  final public void String() throws ParseException {
                /*@bgen(jjtree) String */
  ASTString jjtn000 = new ASTString(this, JJTSTRING);
  boolean jjtc000 = true;
  jjtree.openNodeScope(jjtn000);
  jjtreeOpenNodeScope(jjtn000);
  jjtn000.jjtSetFirstToken(getToken(1));
    try {
      jj_consume_token(QUOTED_STRING);
    } finally {
          if (jjtc000) {
            jjtree.closeNodeScope(jjtn000, true);
            jjtreeCloseNodeScope(jjtn000);
            jjtn000.jjtSetLastToken(getToken(0));
          }
    }
  }

  private boolean jj_2_1(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_1(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(0, xla); }
  }

  private boolean jj_2_2(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_2(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(1, xla); }
  }

  private boolean jj_2_3(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_3(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(2, xla); }
  }

  private boolean jj_3R_4() {
    if (jj_scan_token(LBRC)) return true;
    if (jj_scan_token(RBRC)) return true;
    return false;
  }

  private boolean jj_3R_5() {
    if (jj_scan_token(CLAUSE_DEF)) return true;
    if (jj_scan_token(LPAREN)) return true;
    if (jj_scan_token(CLAUSE_REFERENCE)) return true;
    if (jj_scan_token(RPAREN)) return true;
    return false;
  }

  private boolean jj_3_3() {
    if (jj_3R_2()) return true;
    if (jj_scan_token(LPAREN)) return true;
    return false;
  }

  private boolean jj_3_2() {
    if (jj_scan_token(CLAUSE_DEF)) return true;
    if (jj_scan_token(LPAREN)) return true;
    return false;
  }

  private boolean jj_3R_3() {
    if (jj_3R_5()) return true;
    return false;
  }

  private boolean jj_3R_2() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3R_3()) {
    jj_scanpos = xsp;
    if (jj_scan_token(17)) {
    jj_scanpos = xsp;
    if (jj_scan_token(31)) {
    jj_scanpos = xsp;
    if (jj_scan_token(15)) {
    jj_scanpos = xsp;
    if (jj_3R_4()) return true;
    }
    }
    }
    }
    return false;
  }

  private boolean jj_3_1() {
    if (jj_scan_token(LPAREN)) return true;
    return false;
  }

  /** Generated Token Manager. */
  public CanonicalTermParserTokenManager token_source;
  SimpleCharStream jj_input_stream;
  /** Current token. */
  public Token token;
  /** Next token. */
  public Token jj_nt;
  private int jj_ntk;
  private Token jj_scanpos, jj_lastpos;
  private int jj_la;
  private int jj_gen;
  final private int[] jj_la1 = new int[5];
  static private int[] jj_la1_0;
  static private int[] jj_la1_1;
  static {
      jj_la1_init_0();
      jj_la1_init_1();
   }
   private static void jj_la1_init_0() {
      jj_la1_0 = new int[] {0xa607a800,0x8003a000,0x200,0x26000000,0x6000000,};
   }
   private static void jj_la1_init_1() {
      jj_la1_1 = new int[] {0x1,0x0,0x0,0x0,0x0,};
   }
  final private JJCalls[] jj_2_rtns = new JJCalls[3];
  private boolean jj_rescan = false;
  private int jj_gc = 0;

  /** Constructor with InputStream. */
public CanonicalTermParser(java.io.InputStream stream) {
     this(stream, null);
  }
  /** Constructor with InputStream and supplied encoding */
  public CanonicalTermParser(java.io.InputStream stream, String encoding) {
    try { jj_input_stream = new SimpleCharStream(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source = new CanonicalTermParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 5; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  /** Reinitialise. */
  public void ReInit(java.io.InputStream stream) {
     ReInit(stream, null);
  }
  /** Reinitialise. */
  public void ReInit(java.io.InputStream stream, String encoding) {
    try { jj_input_stream.ReInit(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jjtree.reset();
    jj_gen = 0;
    for (int i = 0; i < 5; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  /** Constructor. */
  public CanonicalTermParser(java.io.Reader stream) {
    jj_input_stream = new SimpleCharStream(stream, 1, 1);
    token_source = new CanonicalTermParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 5; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  /** Reinitialise. */
  public void ReInit(java.io.Reader stream) {
    jj_input_stream.ReInit(stream, 1, 1);
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jjtree.reset();
    jj_gen = 0;
    for (int i = 0; i < 5; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  /** Constructor with generated Token Manager. */
  public CanonicalTermParser(CanonicalTermParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 5; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  /** Reinitialise. */
  public void ReInit(CanonicalTermParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jjtree.reset();
    jj_gen = 0;
    for (int i = 0; i < 5; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  private Token jj_consume_token(int kind) throws ParseException {
    Token oldToken;
    if ((oldToken = token).next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    if (token.kind == kind) {
      jj_gen++;
      if (++jj_gc > 100) {
        jj_gc = 0;
        for (int i = 0; i < jj_2_rtns.length; i++) {
          JJCalls c = jj_2_rtns[i];
          while (c != null) {
            if (c.gen < jj_gen) c.first = null;
            c = c.next;
          }
        }
      }
      return token;
    }
    token = oldToken;
    jj_kind = kind;
    throw generateParseException();
  }

  static private final class LookaheadSuccess extends java.lang.Error {

	private static final long serialVersionUID = 2916935552030986067L; }
  
  final private LookaheadSuccess jj_ls = new LookaheadSuccess();
  private boolean jj_scan_token(int kind) {
    if (jj_scanpos == jj_lastpos) {
      jj_la--;
      if (jj_scanpos.next == null) {
        jj_lastpos = jj_scanpos = jj_scanpos.next = token_source.getNextToken();
      } else {
        jj_lastpos = jj_scanpos = jj_scanpos.next;
      }
    } else {
      jj_scanpos = jj_scanpos.next;
    }
    if (jj_rescan) {
      int i = 0; Token tok = token;
      while (tok != null && tok != jj_scanpos) { i++; tok = tok.next; }
      if (tok != null) jj_add_error_token(kind, i);
    }
    if (jj_scanpos.kind != kind) return true;
    if (jj_la == 0 && jj_scanpos == jj_lastpos) throw jj_ls;
    return false;
  }


/** Get the next Token. */
  final public Token getNextToken() {
    if (token.next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    jj_gen++;
    return token;
  }

/** Get the specific Token. */
  final public Token getToken(int index) {
    Token t = token;
    for (int i = 0; i < index; i++) {
      if (t.next != null) t = t.next;
      else t = t.next = token_source.getNextToken();
    }
    return t;
  }

  private int jj_ntk() {
    if ((jj_nt=token.next) == null)
      return (jj_ntk = (token.next=token_source.getNextToken()).kind);
    else
      return (jj_ntk = jj_nt.kind);
  }

  private java.util.List<int[]> jj_expentries = new java.util.ArrayList<int[]>();
  private int[] jj_expentry;
  private int jj_kind = -1;
  private int[] jj_lasttokens = new int[100];
  private int jj_endpos;

  private void jj_add_error_token(int kind, int pos) {
    if (pos >= 100) return;
    if (pos == jj_endpos + 1) {
      jj_lasttokens[jj_endpos++] = kind;
    } else if (jj_endpos != 0) {
      jj_expentry = new int[jj_endpos];
      for (int i = 0; i < jj_endpos; i++) {
        jj_expentry[i] = jj_lasttokens[i];
      }
      jj_entries_loop: for (java.util.Iterator<?> it = jj_expentries.iterator(); it.hasNext();) {
        int[] oldentry = (int[])(it.next());
        if (oldentry.length == jj_expentry.length) {
          for (int i = 0; i < jj_expentry.length; i++) {
            if (oldentry[i] != jj_expentry[i]) {
              continue jj_entries_loop;
            }
          }
          jj_expentries.add(jj_expentry);
          break jj_entries_loop;
        }
      }
      if (pos != 0) jj_lasttokens[(jj_endpos = pos) - 1] = kind;
    }
  }

  /** Generate ParseException. */
  public ParseException generateParseException() {
    jj_expentries.clear();
    boolean[] la1tokens = new boolean[34];
    if (jj_kind >= 0) {
      la1tokens[jj_kind] = true;
      jj_kind = -1;
    }
    for (int i = 0; i < 5; i++) {
      if (jj_la1[i] == jj_gen) {
        for (int j = 0; j < 32; j++) {
          if ((jj_la1_0[i] & (1<<j)) != 0) {
            la1tokens[j] = true;
          }
          if ((jj_la1_1[i] & (1<<j)) != 0) {
            la1tokens[32+j] = true;
          }
        }
      }
    }
    for (int i = 0; i < 34; i++) {
      if (la1tokens[i]) {
        jj_expentry = new int[1];
        jj_expentry[0] = i;
        jj_expentries.add(jj_expentry);
      }
    }
    jj_endpos = 0;
    jj_rescan_token();
    jj_add_error_token(0, 0);
    int[][] exptokseq = new int[jj_expentries.size()][];
    for (int i = 0; i < jj_expentries.size(); i++) {
      exptokseq[i] = jj_expentries.get(i);
    }
    return new ParseException(token, exptokseq, tokenImage);
  }

  /** Enable tracing. */
  final public void enable_tracing() {
  }

  /** Disable tracing. */
  final public void disable_tracing() {
  }

  private void jj_rescan_token() {
    jj_rescan = true;
    for (int i = 0; i < 3; i++) {
    try {
      JJCalls p = jj_2_rtns[i];
      do {
        if (p.gen > jj_gen) {
          jj_la = p.arg; jj_lastpos = jj_scanpos = p.first;
          switch (i) {
            case 0: jj_3_1(); break;
            case 1: jj_3_2(); break;
            case 2: jj_3_3(); break;
          }
        }
        p = p.next;
      } while (p != null);
      } catch(LookaheadSuccess ls) { }
    }
    jj_rescan = false;
  }

  private void jj_save(int index, int xla) {
    JJCalls p = jj_2_rtns[index];
    while (p.gen > jj_gen) {
      if (p.next == null) { p = p.next = new JJCalls(); break; }
      p = p.next;
    }
    p.gen = jj_gen + xla - jj_la; p.first = token; p.arg = xla;
  }

  static final class JJCalls {
    int gen;
    Token first;
    int arg;
    JJCalls next;
  }

}
