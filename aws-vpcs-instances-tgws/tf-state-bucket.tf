terraform {
  backend "s3" {
    bucket         = "tf-state-bucket-750001" 
    key            = "state/terraform.tfstate"   
    region         = "us-east-1"                 
    encrypt        = true                        
    use_lockfile   = true                        
  }
}