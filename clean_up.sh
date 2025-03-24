#!/bin/bash

echo "🧹 Starting full system cleanup..."

# Show memory usage before
echo "📊 Memory usage BEFORE:"
free -h

# 1. Clear system RAM caches
sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
echo "✅ RAM cache cleared."

# 2. Clean APT
sudo apt-get clean
sudo apt-get autoremove -y
echo "✅ APT cleaned and unused packages removed."

# 3. Clear /tmp and /var/tmp
sudo rm -rf /tmp/* /var/tmp/*
echo "✅ Temp files removed."

# 4. Vacuum old journal logs (older than 3 days)
sudo journalctl --vacuum-time=3d
echo "✅ Old system logs (journalctl) cleaned."

# 5. Docker system cleanup
echo "🐳 Cleaning up Docker..."
docker system prune -af --volumes
echo "✅ Docker system pruned (containers, images, volumes)."

# 6. Truncate Docker container logs (without restarting containers)
echo "🧾 Truncating Docker container logs..."
LOGS=$(find /var/lib/docker/containers/ -type f -name '*-json.log')
for log in $LOGS; do
  sudo truncate -s 0 "$log"
done

echo "✅ Docker logs truncated."

# 7. Show memory usage after
echo "📊 Memory usage AFTER:"
free -h

# 8. Check if reboot is required
if [ -f /var/run/reboot-required ]; then
    echo "⚠️  Reboot is required."

    # Optional: Uncomment to auto-reboot
    # echo "Rebooting now..."
    # sudo reboot
fi

echo "✅ Full cleanup complete."
