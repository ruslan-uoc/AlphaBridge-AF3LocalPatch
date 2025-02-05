# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <seed_number> | best"
    exit 1
fi

SEED_NUMBER=$1

bash AF3_to_AFS.sh $SEED_NUMBER
bash ABridgebatch.sh