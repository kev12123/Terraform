provider "aws" {
  profile = "default" #this is how terraform accesses creds
  region  = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
}
 #allocates and associates elastic IP to an EC2 instance
resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.example.id #interpolating id from EC2 instance 
}
