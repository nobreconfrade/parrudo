.class public Bytecode
.super java/lang/Object

.method public <init>()V
	aload_0

	invokenonvirtual java/lang/Object/<init>()V
	return
.end method

.method public static main([Ljava/lang/String;)V
	.limit stack  10
	.limit locals 10
	ldc 130
	istore 1
	bipush 20
	istore 2
	iconst_2
	istore 3
	iload 3
	iload 1
	iadd
	iload 2
	iadd
	istore 4
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 1
	iload 2
	iadd
	invokevirtual java/io/PrintStream/println(I)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 4
	invokevirtual java/io/PrintStream/println(I)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "oizao zao zao zao aoz"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	return
.end method
