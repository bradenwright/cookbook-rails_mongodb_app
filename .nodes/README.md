# Nodes Path 

Test kitchen directory to store nodes, if Rake is used then after a node is converge the json file from /tmp/kitchen/nodes, for the node that just converged, to this directory.

If 'rake destroy' is ran then this directory will be cleaned up.

Note: If node files aren't managed properly mongodb install will fail.  On the first run the node being converged can not have a file here, or mongodb recipe will fail, it tries to setup replicaset and/or shard on first run and it can't.   After the first run the node must have a file here, or shard/replicaset will be setup but the nodes won't find each other so there will be standalone servers, not a shard/replicaset
