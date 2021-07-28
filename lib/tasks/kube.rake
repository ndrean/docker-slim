# Turn off Rake noise
Rake.application.options.trace = false

namespace :kube do
  desc 'Print useful information aout our Kubernete setup'
  task :list do
    kubectl('kubectl get all --all-namespaces')
  end

  desc 'Create namespace "myns"'
  task :ns do
    kubectl('kubectl create ns myns')
    
  end

  desc 'Apply all manifests'
  namespace :apply do
    task :split do
      kubectl('kubectl apply -f ./kube-split/')
    end
  end

  def kubectl(command)
    system(command)
  end
end