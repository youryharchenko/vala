int main (string[] args) {
	string who = "world";
	if (args.length > 1) {
		who = args[1];
	}
	print ("Hello, %s\n", who);
	return 0;
}