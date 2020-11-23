# gravatar-app
gravatar-app

### Background
Gravatar application returns user profile image from Gravatar base on their registered email address, if the email does not exist then default image is returned

#### Endpoint
http://gravatar-alb-1654954083.us-east-1.elb.amazonaws.com/avatar
#### example  
checking user email `hui.zheng278@gmail.com`
http://gravatar-alb-1654954083.us-east-1.elb.amazonaws.com/avatar/hui.zheng278@gmail.com

Used Terraform to provision all the infrastructure, although I'm more comfortable with Cloudformation, this is a great opportunity to get more experience with Terraform. Picked Docker over Packer, because Docker is sufficient for the scope of the project, I would be happy to use Packer and Jenkins combination in a more complex project.
If given more time, I'll add auto scaling policies to the autoscaling group and ECS service to make the server more scalable and reliable. 