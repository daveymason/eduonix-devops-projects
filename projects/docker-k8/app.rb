require 'sinatra'
require 'mysql2'

set :bind, '0.0.0.0'
set :port, ENV.fetch('PORT', '4567').to_i

def db_client
  Mysql2::Client.new(
    host: ENV.fetch('DB_HOST', 'mysql'),
    username: ENV.fetch('DB_USER', 'appuser'),
    password: ENV.fetch('DB_PASSWORD', 'apppassword'),
    database: ENV.fetch('DB_NAME', 'contact_app')
  )
end

def ensure_table_exists
  db_client.query(<<~SQL)
    CREATE TABLE IF NOT EXISTS submissions (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(150) NOT NULL,
      message TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL
rescue Mysql2::Error
  nil
end

helpers do
  def recent_submissions
    ensure_table_exists
    db_client.query('SELECT name, email, message, created_at FROM submissions ORDER BY id DESC LIMIT 5')
  rescue Mysql2::Error
    []
  end
end

before do
  ensure_table_exists
end

get '/' do
  @status = params['status']
  @submissions = recent_submissions
  erb :index
end

post '/submit' do
  name = params['name'].to_s.strip
  email = params['email'].to_s.strip
  message = params['message'].to_s.strip

  if [name, email, message].any?(&:empty?)
    redirect '/?status=missing'
  end

  begin
    client = db_client
    statement = client.prepare('INSERT INTO submissions (name, email, message) VALUES (?, ?, ?)')
    statement.execute(name, email, message)
    redirect '/?status=success'
  rescue Mysql2::Error
    redirect '/?status=error'
  end
end

__END__

@@ layout
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ruby Web Form</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background: #f4f7fb;
        color: #1f2937;
        margin: 0;
        padding: 32px 16px;
      }

      .page {
        max-width: 760px;
        margin: 0 auto;
        background: #ffffff;
        border-radius: 16px;
        padding: 32px;
        box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
      }

      h1 {
        margin-top: 0;
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
        background: #2563eb;
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

      .list {
        margin-top: 32px;
      }

      .entry {
        padding: 14px 0;
        border-top: 1px solid #e5e7eb;
      }
    </style>
  </head>
  <body>
    <main class="page">
      <%= yield %>
    </main>
  </body>
</html>

@@ index
<h1>Ruby Contact Form</h1>
<p>This is a simple Ruby web form backed by MySQL and intended for Docker and Kubernetes deployment.</p>

<% if @status == 'success' %>
  <div class="status success">Submission saved successfully.</div>
<% elsif @status == 'missing' %>
  <div class="status error">Please fill in all fields.</div>
<% elsif @status == 'error' %>
  <div class="status error">Database connection failed. Check the app and MySQL containers.</div>
<% end %>

<form method="post" action="/submit">
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

<section class="list">
  <h2>Recent Submissions</h2>
  <% if @submissions.empty? %>
    <p>No submissions yet.</p>
  <% else %>
    <% @submissions.each do |submission| %>
      <div class="entry">
        <strong><%= submission['name'] %></strong> - <%= submission['email'] %><br>
        <span><%= submission['message'] %></span>
      </div>
    <% end %>
  <% end %>
</section>
