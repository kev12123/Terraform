provider "aws" {
  profile = "default" #this is how terraform accesses creds
  region  = "us-east-1"
}

#allocated an s3 bucket that the application will use
resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "terraform-getting-started-guide"
  acl    = "private"
}

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"

  #Tells Terraform that this EC2 instance must be created only after
  #the s3 bucket has been created
  depends_on = [aws_s3_bucket.example] #depends_on is used to declare explitit dependencies
}

#allocating another EC2 instance that can be added in parallel with other resources since it has no dependencies
resource "aws_instance" "another" {
    ami = "ami-b374d5a5"
    instance_type = "t2.micro"
}

#allocates and associates elastic IP to an EC2 instance
resource "aws_eip" "ip" { 
  vpc = true
  instance = aws_instance.example.id #interpolating id from EC2 instance. This interpolation creates an implicit dependency that allows terraform to determine the order of execution in it's plan
}
