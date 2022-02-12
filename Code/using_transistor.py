from transistor import Transistor
from matplotlib import pyplot as plt

t = Transistor(0.5, 0.6, 3, 3, 0.5)

fig = plt.figure()
plt.plot(t.position_range(), t.phi())

plt.title("Phi")
plt.xlabel("Position [nm]")
plt.ylabel("E [eV]")


## plot DOS
plt.figure()
p = plt.pcolor(t.position_range(), t.energy_range(), t.DOS)
# p = surf(x_range, E_range, obj.DOS);
plt.title("DOS")
# set(fig, 'name', 'DOS');
# view(2); % X-Y
# shading flat;
plt.xlabel("Position [nm]")
plt.ylabel("E [eV]")
##

plt.show()
