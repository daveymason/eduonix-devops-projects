<?php
$status = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $message = trim($_POST['message'] ?? '');

    if ($name === '' || $email === '' || $message === '') {
        $status = 'missing';
    } else {
        $host = getenv('DB_HOST') ?: 'mysql';
        $db = getenv('DB_NAME') ?: 'contact_app';
        $user = getenv('DB_USER') ?: 'appuser';
        $pass = getenv('DB_PASSWORD') ?: 'apppassword';

        try {
            $pdo = new PDO("mysql:host={$host};dbname={$db};charset=utf8mb4", $user, $pass);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            $pdo->exec(
                'CREATE TABLE IF NOT EXISTS submissions (' .
                'id INT AUTO_INCREMENT PRIMARY KEY,' .
                'name VARCHAR(100) NOT NULL,' .
                'email VARCHAR(150) NOT NULL,' .
                'message TEXT NOT NULL,' .
                'created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)'
            );

            $stmt = $pdo->prepare('INSERT INTO submissions (name, email, message) VALUES (?, ?, ?)');
            $stmt->execute([$name, $email, $message]);
            $status = 'success';
        } catch (Throwable $exception) {
            $status = 'error';
        }
    }
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>PHP Contact Form</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f4f7fb;
      color: #1f2937;
      margin: 0;
      padding: 32px 16px;
    }

    .page {
      max-width: 720px;
      margin: 0 auto;
      background: #ffffff;
      border-radius: 16px;
      padding: 32px;
      box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
    }

    form {
      display: grid;
      gap: 16px;
      margin-top: 24px;
    }

    input,
    textarea {
      width: 100%;
      padding: 12px;
      border: 1px solid #cbd5e1;
      border-radius: 10px;
      box-sizing: border-box;
      font: inherit;
    }

    button {
      width: fit-content;
      padding: 12px 18px;
      border: 0;
      border-radius: 10px;
      background: #16a34a;
      color: #ffffff;
      font: inherit;
      cursor: pointer;
    }

    .status {
      margin-top: 16px;
      padding: 12px 14px;
      border-radius: 10px;
    }

    .success {
      background: #dcfce7;
      color: #166534;
    }

    .error {
      background: #fee2e2;
      color: #991b1b;
    }
  </style>
</head>
<body>
  <main class="page">
    <h1>PHP Contact Form</h1>
    <p>This is the minimal PHP version of the same MySQL-backed form, added to satisfy the traditional LAMP-style requirement.</p>

    <?php if ($status === 'success'): ?>
      <div class="status success">Submission saved successfully.</div>
    <?php elseif ($status === 'missing'): ?>
      <div class="status error">Please fill in all fields.</div>
    <?php elseif ($status === 'error'): ?>
      <div class="status error">Database connection failed. Check the PHP app and MySQL containers.</div>
    <?php endif; ?>

    <form method="post">
      <div>
        <label for="name">Name</label>
        <input id="name" name="name" type="text" required>
      </div>

      <div>
        <label for="email">Email</label>
        <input id="email" name="email" type="email" required>
      </div>

      <div>
        <label for="message">Message</label>
        <textarea id="message" name="message" rows="5" required></textarea>
      </div>

      <button type="submit">Submit</button>
    </form>
  </main>
</body>
</html>
