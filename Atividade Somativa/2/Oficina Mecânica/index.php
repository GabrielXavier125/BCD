<?php
require_once 'config.php';

// Contar registros para o dashboard
function contar($pdo, $tabela) {
    return (int)$pdo->query("SELECT COUNT(*) AS total FROM {$tabela}")->fetch()['total'];
}

$page = $_GET['page'] ?? 'dashboard';
$validPages = ['dashboard','clientes','veiculos','mecanicos','servicos','pecas','os'];
if (!in_array($page, $validPages)) {
    $page = 'dashboard';
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Painel - Oficina Mecânica (PHP)</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="layout">
    <aside class="sidebar">
      <div class="logo">
        <span class="logo-icon">🔧</span>
        <span class="logo-text">Oficina Pro</span>
      </div>
      <nav class="menu">
        <a class="menu-item <?php echo $page==='dashboard'?'active':''; ?>" href="index.php?page=dashboard">Dashboard</a>
        <a class="menu-item <?php echo $page==='clientes'?'active':''; ?>" href="index.php?page=clientes">Clientes</a>
        <a class="menu-item <?php echo $page==='veiculos'?'active':''; ?>" href="index.php?page=veiculos">Veículos</a>
        <a class="menu-item <?php echo $page==='mecanicos'?'active':''; ?>" href="index.php?page=mecanicos">Mecânicos</a>
        <a class="menu-item <?php echo $page==='servicos'?'active':''; ?>" href="index.php?page=servicos">Serviços</a>
        <a class="menu-item <?php echo $page==='pecas'?'active':''; ?>" href="index.php?page=pecas">Peças</a>
        <a class="menu-item <?php echo $page==='os'?'active':''; ?>" href="index.php?page=os">Ordens de Serviço</a>
      </nav>
      <footer class="sidebar-footer">
        <small>Painel Administrativo<br>Oficina Mecânica (PHP + MySQL)</small>
      </footer>
    </aside>

    <main class="main">
      <header class="topbar">
        <h1>Painel da Oficina</h1>
        <span class="badge">Layout integrado (HTML/CSS) + PHP</span>
      </header>

      <?php if ($page === 'dashboard'): ?>
        <section class="section">
          <h2>Visão Geral</h2>
          <div class="cards">
            <div class="card">
              <h3>Clientes</h3>
              <p class="big-number"><?php echo contar($pdo, 'clientes'); ?></p>
              <p>Total de clientes cadastrados</p>
            </div>
            <div class="card">
              <h3>Veículos</h3>
              <p class="big-number"><?php echo contar($pdo, 'veiculos'); ?></p>
              <p>Veículos vinculados a clientes</p>
            </div>
            <div class="card">
              <h3>Mecânicos</h3>
              <p class="big-number"><?php echo contar($pdo, 'mecanicos'); ?></p>
              <p>Equipe disponível</p>
            </div>
            <div class="card">
              <h3>Ordens de Serviço</h3>
              <p class="big-number"><?php echo contar($pdo, 'ordens_servico'); ?></p>
              <p>OS cadastradas</p>
            </div>
          </div>
        </section>
      <?php else: ?>
        <section class="section">
          <?php include __DIR__ . '/pages/' . $page . '.php'; ?>
        </section>
      <?php endif; ?>

    </main>
  </div>
</body>
</html>
