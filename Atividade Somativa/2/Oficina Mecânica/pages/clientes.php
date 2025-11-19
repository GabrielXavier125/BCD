<?php
// CRUD de clientes

// CREATE / UPDATE
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id        = $_POST['id_cliente'] ?? '';
    $nome      = trim($_POST['nome'] ?? '');
    $telefone  = trim($_POST['telefone'] ?? '');
    $email     = trim($_POST['email'] ?? '');
    $cpf       = trim($_POST['cpf'] ?? '');
    $endereco  = trim($_POST['endereco'] ?? '');

    if ($nome !== '') {
        if ($id) {
            $stmt = $pdo->prepare("UPDATE clientes 
                                   SET nome=?, telefone=?, email=?, cpf=?, endereco=? 
                                   WHERE id_cliente=?");
            $stmt->execute([$nome, $telefone, $email, $cpf, $endereco, $id]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO clientes (nome, telefone, email, cpf, endereco)
                                   VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$nome, $telefone, $email, $cpf, $endereco]);
        }
    }
    header("Location: index.php?page=clientes");
    exit;
}

// DELETE
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare("DELETE FROM clientes WHERE id_cliente = ?")->execute([$id]);
    header("Location: index.php?page=clientes");
    exit;
}

// EDIT
$clienteEdicao = null;
if (isset($_GET['edit'])) {
    $id = (int)$_GET['edit'];
    $stmt = $pdo->prepare("SELECT * FROM clientes WHERE id_cliente = ?");
    $stmt->execute([$id]);
    $clienteEdicao = $stmt->fetch();
}

// LISTA
$clientes = $pdo->query("SELECT * FROM clientes ORDER BY nome")->fetchAll();
?>
<div class="section-header">
  <h2>Clientes</h2>
</div>

<div class="grid-2">
  <div class="card form-card">
    <h3><?php echo $clienteEdicao ? 'Editar Cliente' : 'Novo Cliente'; ?></h3>
    <form method="post">
      <input type="hidden" name="id_cliente" value="<?php echo $clienteEdicao['id_cliente'] ?? ''; ?>">
      <div class="form-group">
        <label>Nome</label>
        <input type="text" name="nome" required
               value="<?php echo htmlspecialchars($clienteEdicao['nome'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Telefone</label>
        <input type="text" name="telefone"
               value="<?php echo htmlspecialchars($clienteEdicao['telefone'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>E-mail</label>
        <input type="email" name="email"
               value="<?php echo htmlspecialchars($clienteEdicao['email'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>CPF</label>
        <input type="text" name="cpf"
               value="<?php echo htmlspecialchars($clienteEdicao['cpf'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Endereço</label>
        <input type="text" name="endereco"
               value="<?php echo htmlspecialchars($clienteEdicao['endereco'] ?? ''); ?>">
      </div>
      <button type="submit" class="btn primary">
        <?php echo $clienteEdicao ? 'Atualizar' : 'Salvar'; ?>
      </button>
      <?php if ($clienteEdicao): ?>
        <a href="index.php?page=clientes" class="btn secondary">Cancelar</a>
      <?php endif; ?>
    </form>
  </div>

  <div class="card">
    <h3>Lista de Clientes</h3>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Telefone</th>
            <th>E-mail</th>
            <th>CPF</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($clientes as $c): ?>
            <tr>
              <td><?php echo $c['id_cliente']; ?></td>
              <td><?php echo htmlspecialchars($c['nome']); ?></td>
              <td><?php echo htmlspecialchars($c['telefone']); ?></td>
              <td><?php echo htmlspecialchars($c['email']); ?></td>
              <td><?php echo htmlspecialchars($c['cpf']); ?></td>
              <td>
                <a class="btn secondary" href="index.php?page=clientes&edit=<?php echo $c['id_cliente']; ?>">Editar</a>
                <a class="btn danger" href="index.php?page=clientes&delete=<?php echo $c['id_cliente']; ?>"
                   onclick="return confirm('Deseja realmente excluir este cliente?');">
                  Excluir
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
