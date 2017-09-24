import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from matplotlib import pyplot

# Fetch the service account key JSON file contents
cred = credentials.Certificate('/Users/Abhi/Downloads/novesta-da8f8-firebase-adminsdk-8r3tj-30eaefb576.json')

# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://novesta-da8f8.firebaseio.com'
})

# As an admin, the app has access to read and write all data, regradless of Security Rules
timeFrame = [ ]
t= []
i =0
vals = []

ref = db.reference('history_crypto')

snapshot = ref.order_by_key().get()
for key, val in snapshot.items():
    t1 = []
    cval = []
    cval.append(val['1'])
    cval.append(val['2'])
    cval.append(val['3'])
    cval.append(val['4'])
    cval.append(val['5'])
    cval.append(val['6'])
    cval.append(val['7'])
    cval.append(val['8'])
    cval.append(val['9'])
    cval.append(val['10'])
    cval.append(val['11'])
    cval.append(val['12'])
    vals.append(cval)
    t1.append(0)
    t1.append(1)
    t1.append(2)
    t1.append(3)
    t1.append(4)
    t1.append(5)
    t1.append(6)
    t1.append(7)
    t1.append(8)
    t1.append(9)
    t1.append(10)
    t1.append(11)
    t.append(t1)

#print t
#print vals

plot = pyplot.plot(t[0],vals[0],"-")
plot2 = pyplot.plot(t[1],vals[1],"-b")
plot3 = pyplot.plot(t[2],vals[2],"-r")
plot4 = pyplot.plot(t[3],vals[3],"-g")
plot5 = pyplot.plot(t[4],vals[4],"--")
plot6 = pyplot.plot(t[5],vals[5],"o")

pyplot.show()






