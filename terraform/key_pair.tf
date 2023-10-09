resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = file(var.ssh_public_key)

  tags = {
    "Name" = "terraform"
  }
}