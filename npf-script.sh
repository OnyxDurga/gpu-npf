cd
sudo rm -r npf-results/base/results
./npf/npf-run.py --test npf-scripts/script-base.npf --cluster joyeux=joyeux --show-full --show-all
mv results/ npf-results/base/

sudo rm -r npf-results/gpu/results
./npf/npf-run.py --test npf-scripts/script-gpu.npf --cluster joyeux=joyeux --show-full --show-all
mv results/ npf-results/gpu/

sudo rm -r npf-results/dpu/results
./npf/npf-run.py --test npf-scripts/script-dpu.npf --cluster smartnic=smartnic joyeux=joyeux --show-full --show-all
mv results/ npf-results/dpu/

killall -9 click