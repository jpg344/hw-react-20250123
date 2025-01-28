terraform { 
  cloud { 
    
    organization = "react-app-githubworkflow" 

    workspaces { 
      name = "react-app-workspace" 
    } 
  } 
}