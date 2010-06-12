import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Scope extends JApplet {

	public void init() {
		ScopePanel scopePanel = new ScopePanel();
		getContentPane().add(scopePanel, BorderLayout.CENTER);
		fork(scopePanel);
	}


	public static void main(String[] args) throws InterruptedException {
		ScopePanel scopePanel = new ScopePanel();

		JFrame f = new JFrame("Texzyme Javascope");
		f.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
		f.getContentPane().add(scopePanel, BorderLayout.CENTER);
		f.setSize(621+6, 356+16);
		f.setVisible(true);
		fork(scopePanel);
	}

	static void fork(ScopePanel scopePanel) {
		(new Thread(scopePanel, "Scope Refresh")).start();
	}
}

class ScopePanel extends JPanel implements Runnable {
	Point from = new Point(0,0);
	Point to = new Point(0,0);

	public ScopePanel() {
		addMouseListener(new MouseAdapter() {
			public void mousePressed (MouseEvent e) {
				from = e.getPoint();
			}
			public void mouseReleased (MouseEvent e) {
				to = e.getPoint();
			}
		});
		addMouseMotionListener(new MouseMotionAdapter() {
			public void mouseDragged (MouseEvent e) {
				to = e.getPoint();
			}
		});
	 }


	public void run() {
	try {
			while (true) {
				Thread.sleep(25);
				repaint();
			}
		}
		catch (InterruptedException e) {
			System.out.println(e.getMessage());
		}
	}

	public void paintComponent(Graphics g) {
		super.paintComponent(g); //paint background

		g.setColor(Color.gray);
		g.drawString("drag to draw", 20, 15);

		g.setColor(Color.yellow);
		g.fillOval(from.x, from.y, to.x-from.x, to.y-from.y);
		g.setColor(Color.yellow.darker());
		g.drawOval(from.x, from.y, to.x-from.x, to.y-from.y);

		g.setColor(Color.black);
		g.drawLine(from.x, from.y, to.x, to.y);
	}
}