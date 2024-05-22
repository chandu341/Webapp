# main.tf

provider "aws" {
  region = "us-west-2"  # Specify the desired region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Specify the AMI ID
  instance_type = "t2.micro"               # Specify the instance type

  tags = {
    Name = "ExampleInstance"
  }

  # Add key pair to access the instance
  key_name = "your-key-pair"  # Replace with your key pair name
}

# Optional: output the instance's public IP
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
