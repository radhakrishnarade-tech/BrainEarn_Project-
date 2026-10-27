import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _coins = 0;
  int _currentDay = 1;

  void _claimDailyBonus() {
    if (_currentDay <= 7) {
      setState(() {
        _coins += 5;
        _currentDay++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('5 Coins Claimed Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BrainEarn'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              backgroundColor: Colors.amber,
              label: Text('$_coins Coins', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello ${widget.userName}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 15),
              Card(
                color: Colors.deepPurple.shade50,
                child: ListTile(
                  title: Text('Daily Login (Day $_currentDay/7)'),
                  subtitle: const Text('Claim 5 coins every day'),
                  trailing: ElevatedButton(
                    onPressed: _currentDay > 7 ? null : _claimDailyBonus,
                    child: const Text('Claim'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Available Games', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _gameCard(Icons.security, 'Captcha Entry', '15 Seconds Speed Test', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CaptchaGame(onReward: () => setState(() => _coins += 5))));
              }),
              _gameCard(Icons.extension, 'Word Jumble', 'Arrange the letters correctly', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WordGame(onReward: () => setState(() => _coins += 5))));
              }),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green),
                icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
                label: const Text('Wallet Brain', style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(currentCoins: _coins)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gameCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
class CaptchaGame extends StatefulWidget {
  final VoidCallback onReward;
  const CaptchaGame({super.key, required this.onReward});

  @override
  State<CaptchaGame> createState() => _CaptchaGameState();
}

class _CaptchaGameState extends State<CaptchaGame> {
  String _captcha = "";
  final TextEditingController _controller = TextEditingController();
  int _timeLeft = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
    _startTimer();
  }

  void _generateCaptcha() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    _captcha = List.generate(6, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        _showTimeoutDialog();
      }
    });
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Time Out!'),
        content: const Text('You failed to type within 15 seconds. Watch an ad to retry.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateCaptcha();
              _startTimer();
            },
            child: const Text('Watch Ad & Retry'),
          )
        ],
      ),
    );
  }

  void _checkCaptcha() {
    if (_controller.text == _captcha) {
      _timer?.cancel();
      widget.onReward();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correct! 5 Coins Added')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong Captcha! Try again.')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captcha Test'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Time Left: $_timeLeft seconds', style: TextStyle(fontSize: 20, color: _timeLeft < 5 ? Colors.red : Colors.black)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              backgroundColor: Colors.grey.shade300,
              child: Text(_captcha, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5, fontStyle: FontStyle.italic)),
            ),
            const SizedBox(height: 20),
            TextField(controller: _controller, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter Captcha Here')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _checkCaptcha, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class WordGame extends StatefulWidget {
  final VoidCallback onReward;
  const WordGame({super.key, required this.onReward});

  @override
  State<WordGame> createState() => _WordGameState();
}

class _WordGameState extends State<WordGame> {
  final String _correctWord = "APPLE";
  final String _jumbledWord = "APLPE";
  final TextEditingController _controller = TextEditingController();

  void _checkWord() {
    if (_controller.text.toUpperCase() == _correctWord) {
      widget.onReward();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correct Word! 5 Coins Added')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect! Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Match'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Arrange the letters to make a correct word:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text(_jumbledWord, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 8)),
            const SizedBox(height: 30),
            TextField(controller: _controller, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Your Answer')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _checkWord, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  final int currentCoins;
  const WalletScreen({super.key, required this.currentCoins});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wallet Brain'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Payout Options'),
              Tab(text: 'Pending'),
              Tab(text: 'Success'),
              Tab(text: 'Failed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _payoutOptionsView(),
            _historyListView('Pending Payouts (Processed in 24 Hours)'),
            _historyListView('Successful Transactions'),
            _historyListView('Failed Transactions'),
          ],
        ),
      ),
    );
  }

  Widget _payoutOptionsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.amber.shade100,
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.orange),
              title: const Text('Your Balance', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text('$currentCoins Coins', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Select Payment Method:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                _payoutTile('PayPal', '600 Coins = \$5 | 1200 Coins = \$10'),
                _payoutTile('Paytm', '600 Coins = ₹400'),
                _payoutTile('UPI ID', 'Direct Bank Transfer'),
                _payoutTile('Amazon Gift Card', 'Digital Voucher Code'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _payoutTile(String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.payment, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const ElevatedButton(onPressed: null, child: Text('Redeem')),
      ),
    );
  }

  Widget _historyListView(String type) {
    return Center(child: Text(type, style: const TextStyle(fontSize: 16, color: Colors.grey)));
  }
}
