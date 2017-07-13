#!/bin/bash

# (required) Provides test access to provisioned cluster
./ccp_src/aws/setup_ssh_to_cluster.sh

# Copy test source code to cluster node
copy_check-gpdb_src() {
    local gpdb_host=$1
    scp -q -r check-gpdb_src $gpdb_host:/home/gpadmin/
}

run_check-gpdb_test() {
    local gpdb_host=$1

    ssh $gpdb_host "bash -c \"\
        # Setup environment
        source /usr/local/greenplum-db-devel/greenplum_path.sh; \
        export PGDATABASE=footest; \
        export PGPORT=5432; \
        export MASTER_DATA_DIRECTORY=/data/master/gpseg-1; \
        createdb ${PGDATABASE}; \
        # Run check-gpdb test
        cd /home/gpadmin/check-gpdb_src/src/tests/; \
        ./check-gpdb.sh; \
    \""
}

# Look at ~/.ssh/config for available hosts
copy_check-gpdb_src mdw
run_check-gpdb_test mdw
