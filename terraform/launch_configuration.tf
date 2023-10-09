resource "aws_launch_configuration" "ecs_launch_config" {

    associate_public_ip_address = true
    image_id             = data.aws_ami.default.id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_sg.id]
    instance_type        = var.worker_instance_type
    user_data            = file("user_data.sh")
    key_name             = "terraform"

    

    root_block_device {
        volume_size = 30
        volume_type = "gp2"
   }

}

